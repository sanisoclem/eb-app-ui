export const onRequestPost: PagesFunction<{
  LEDGER_DO: DurableObjectNamespace;
}> = async ({ request, env }) => {
  const payload = await request.text();
  try {
    const id = env.LEDGER_DO.newUniqueId();
    const stub = env.LEDGER_DO.get(id);
    await stub.fetch("https://eb-app-ui.pages.dev", {
      method: "POST",
      body: payload,
    });
    return new Response(id.toString());
  } catch (e: any) {
    console.log(e);
    return new Response(`Hello, world! ${payload} ${JSON.stringify(e.message)}`);
  }
};
