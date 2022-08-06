export const onRequestGet: PagesFunction<{LEDGER_DO: DurableObjectNamespace }> = async ({ env, params }) => {
  const id = env.LEDGER_DO.idFromString(params.id as string);
  const stub = env.LEDGER_DO.get(id);
  return await stub.fetch("https://eb-app-ui.pages.dev");
}

export const onRequestPut: PagesFunction<{LEDGER_DO: DurableObjectNamespace }> = async ({ request, env, params }) => {
  const id = env.LEDGER_DO.idFromString(params.id as string);
  const stub = env.LEDGER_DO.get(id);
  return await stub.fetch("https://eb-app-ui.pages.dev", { method: "PUT", body: request.body })
}