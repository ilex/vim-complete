import asyncio
import jedi
import json


def completions(src, line, col, path):
    script = jedi.Script(src, line, col, path)
    res = script.completions()

    return [{
        'name': c.name,
        'description': c.description,
        'complete': c.complete
    } for c in res]


async def handle_echo(reader, writer):
    while not reader.at_eof():
        data = await reader.readline()
        message = data.decode()

        if not message:
            break

        # addr = writer.get_extra_info('peername')
        # print("Received %r from %r" % (message, addr))

        request = json.loads(message)
        response = completions(**request[1])

        r = json.dumps([request[0], response])
        # print("Send: %r" % r)
        writer.write(r.encode())
        await writer.drain()

    print("Close the client socket")
    writer.close()

loop = asyncio.get_event_loop()
coro = asyncio.start_server(handle_echo, '127.0.0.1', 8888, loop=loop)
server = loop.run_until_complete(coro)

# Serve requests until Ctrl+C is pressed
print('Serving on {}'.format(server.sockets[0].getsockname()))
try:
    loop.run_forever()
except KeyboardInterrupt:
    pass

# Close the server
server.close()
loop.run_until_complete(server.wait_closed())
loop.close()
