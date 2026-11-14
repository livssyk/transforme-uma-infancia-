/* =====================================================================
   T.U.I. — Transforme Uma Infância
   ARQUIVO DE CONFIGURAÇÃO
   ---------------------------------------------------------------------
   Este é o ÚNICO arquivo que você precisa editar para ligar o site
   ao banco de dados online (Supabase) e trocar contatos.

   Passo a passo completo: veja o README.md (seção "Banco de dados").
   ===================================================================== */

window.TUI_CONFIG = {

  /* ---- 1) BANCO DE DADOS ONLINE (Supabase) ---------------------------
     No painel do Supabase: Project Settings > API Keys (ou API).
     - "Project URL"  -> cole em supabaseUrl
     - "anon public"  -> cole em supabaseAnonKey
     Enquanto estiver com os textos COLE_AQUI, o site funciona no modo
     local (salva só no navegador) e avisa no rodapé do formulário.       */
  supabaseUrl: "https://zakzqucqhtawkspvkgih.supabase.co",
  supabaseAnonKey: "sb_publishable_T8FRjbHHWIR6wFYGv7eDWg_mPlQllD6",

  /* ---- 2) CONTATO ---------------------------------------------------
     Número do WhatsApp com DDI+DDD, apenas dígitos.                      */
  email: "projeto.transformeumainfancia@gmail.com",

  /* ---- 3) OPÇÕES ---------------------------------------------------- */
  // Ponto de entrega exibido nos textos
  pontoDeEntrega: "Colégio Atheneu — Rua Juiz de Fora, 185 — Vila Virgínia, Itaquaquecetuba — SP, 08573-060"
};
