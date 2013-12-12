import sys

import eventlet
import swift.common.direct_client
import swiftly.client.directclient


ACCOUNT = sys.argv[1]
CONTAINER = sys.argv[2]
OBJECT_RING = None
CLIENTS = eventlet.queue.Queue()
CHECK_OBJECTS = []


def check_object(obj, output=False):
    name = obj['name'].encode('utf-8')
    partition, nodes = OBJECT_RING.get_nodes(ACCOUNT, CONTAINER, name)
    etags = []
    for node in nodes:
        etag = None
        for attempt in xrange(3):
            try:
                headers = swift.common.direct_client.direct_head_object(
                    node, partition, ACCOUNT, CONTAINER, obj['name'])
                etag = headers.get('etag').strip('"')
                break
            except (eventlet.Timeout, Exception):
                pass
        etags.append(etag)
    if not any(etags):
        if output:
            print '404', repr(obj['name'])
            sys.stdout.flush()
        else:
            print >>sys.stderr, 'Possible 404', repr(obj['name'])
            sys.stderr.flush()
            CHECK_OBJECTS.append(obj)
    else:
        for etag in etags:
            if etag and etag != obj['hash']:
                if output:
                    print '---', repr(obj['name']), obj['hash'], etag
                    sys.stdout.flush()
                else:
                    print >>sys.stderr, 'Possible ---', repr(obj['name']), \
                        obj['hash'], etag
                    sys.stderr.flush()
                    CHECK_OBJECTS.append(obj)
                break


client = swiftly.client.directclient.DirectClient(
    swift_proxy_storage_path='/v1/' + ACCOUNT)
OBJECT_RING = client.swift_proxy.object_ring
pool = eventlet.GreenPool(size=30)
marker = None
count = 0
while True:
    status, reason, headers, objects = client.get_container(
        CONTAINER, marker=marker)
    if status // 100 != 2:
        raise Exception('CONTAINER LISTING ERROR %s %s' % (status, reason))
    if not objects:
        break
    for obj in objects:
        pool.spawn_n(check_object, obj)
        marker = obj['name']
        count += 1
        if count % 1000 == 0:
            print >>sys.stderr, count
            sys.stderr.flush()
print >>sys.stderr, count, 'and waiting'
sys.stderr.flush()
pool.waitall()

for obj in CHECK_OBJECTS:
    check_object(obj, output=True)
