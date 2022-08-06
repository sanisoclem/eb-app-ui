export const onRequestPost: PagesFunction<{
  LEDGER_DO: DurableObjectNamespace;
}> = async ({ request, env }) => {
  try {
    let id = env.LEDGER_DO.newUniqueId();
    const stub = env.LEDGER_DO.get(id);
    return await stub.fetch("https://eb-app-ui.pages.dev", {
      method: "POST",
      body: await request.json(),
    });
  } catch (e) {
    console.log(e);
    return new Response(`Hello, world! ${JSON.stringify(e)}`);
  }
};
