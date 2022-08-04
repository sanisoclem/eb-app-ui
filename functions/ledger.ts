export const onRequestPost: PagesFunction<{LEDGER_DO: DurableObjectNamespace }> = async ({ request, env }) => {
  let id = env.LEDGER_DO.newUniqueId();
  const stub = env.LEDGER_DO.get(id);
  //return await stub.fetch("", { method: "POST", body: request.body })
  return new Response(`Hello test`)
}