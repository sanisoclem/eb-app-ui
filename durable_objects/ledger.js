
export class Ledger {
  constructor(state) {
    this.state = state;
  }

  async fetch(request) {
    switch (request.method) {
      case 'POST':
      case 'PUT':
        await this.state.storage.put("ledger", await request.json())
        return new Response('OK', { status: 200 });
      case 'DELETE':
        await this.state.storage.delete("ledger");
        return new Response('OK', { status: 200 });
      case 'GET':
        return jsonResponse(await this.state.storage.get("ledger"));
    }
  }
}