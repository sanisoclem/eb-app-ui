export const onRequestGet: PagesFunction<{LEDGER_DO: DurableObjectNamespace }> = async ({ env, params }) => {
  const id = env.LEDGER_DO.idFromString(params.id as string);
  const stub = env.LEDGER_DO.get(id);
  return await stub.fetch("");
}

export const onRequestPut: PagesFunction<{LEDGER_DO: DurableObjectNamespace }> = async ({ request, env, params }) => {
  const id = env.LEDGER_DO.idFromString(params.id as string);
  const stub = env.LEDGER_DO.get(id);
  return await stub.fetch("", { method: "PUT", body: request.body })
}