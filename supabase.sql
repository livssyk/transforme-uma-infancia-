-- =====================================================================
-- T.U.I. — Transforme Uma Infância
-- Script de criação do banco de dados online (Supabase / PostgreSQL)
-- ---------------------------------------------------------------------
-- COMO USAR:
-- 1) Crie um projeto gratuito em https://supabase.com
-- 2) No painel, abra "SQL Editor" > "New query"
-- 3) Cole TODO este arquivo e clique em "Run"
-- 4) Copie a Project URL e a chave "anon public" (Project Settings > API)
--    e cole no arquivo config.js do site.
-- ---------------------------------------------------------------------
-- Segurança (RLS):
--   - Qualquer visitante do site pode INSERIR cadastro/doação (anon)
--   - Somente a equipe LOGADA (authenticated) pode LER e EXCLUIR
--   - Ninguém anônimo consegue listar os dados das pessoas
-- =====================================================================

-- ---------- 1) CADASTROS ----------
create table if not exists public.tui_cadastros (
  id          uuid primary key default gen_random_uuid(),
  criado_em   timestamptz not null default now(),
  nome        text not null check (char_length(nome) between 2 and 120),
  email       text not null check (char_length(email) between 5 and 160),
  telefone    text check (char_length(telefone) <= 20),
  cidade      text check (char_length(cidade) <= 90),
  perfil      text check (char_length(perfil) <= 40)
);

-- ---------- 2) DOAÇÕES ----------
create table if not exists public.tui_doacoes (
  id              uuid primary key default gen_random_uuid(),
  criado_em       timestamptz not null default now(),
  nome            text not null check (char_length(nome) between 2 and 120),
  whatsapp        text check (char_length(whatsapp) <= 20),
  itens           text[] not null default '{}',
  quantidade      integer check (quantidade is null or (quantidade >= 1 and quantidade <= 9999)),
  tamanho_fralda  text check (char_length(tamanho_fralda) <= 60),
  observacao      text check (char_length(observacao) <= 800),
  origem          text default 'site'
);

-- ---------- 3) ÍNDICES (deixam o painel mais rápido) ----------
create index if not exists tui_cadastros_data_idx on public.tui_cadastros (criado_em desc);
create index if not exists tui_doacoes_data_idx   on public.tui_doacoes   (criado_em desc);

-- ---------- 4) ATIVAR SEGURANÇA (RLS) ----------
alter table public.tui_cadastros enable row level security;
alter table public.tui_doacoes   enable row level security;

-- ---------- 5) PERMISSÕES POR PAPEL ----------
grant insert on public.tui_cadastros to anon;
grant insert on public.tui_doacoes   to anon;
grant select, delete on public.tui_cadastros to authenticated;
grant select, delete on public.tui_doacoes   to authenticated;

-- ---------- 6) POLÍTICAS ----------
-- Visitante do site pode enviar (mas não ler)
drop policy if exists "site pode registrar cadastro" on public.tui_cadastros;
create policy "site pode registrar cadastro"
  on public.tui_cadastros for insert to anon with check (true);

drop policy if exists "site pode registrar doacao" on public.tui_doacoes;
create policy "site pode registrar doacao"
  on public.tui_doacoes for insert to anon with check (true);

-- Equipe logada pode ler
drop policy if exists "equipe le cadastros" on public.tui_cadastros;
create policy "equipe le cadastros"
  on public.tui_cadastros for select to authenticated using (true);

drop policy if exists "equipe le doacoes" on public.tui_doacoes;
create policy "equipe le doacoes"
  on public.tui_doacoes for select to authenticated using (true);

-- Equipe logada pode excluir
drop policy if exists "equipe exclui cadastros" on public.tui_cadastros;
create policy "equipe exclui cadastros"
  on public.tui_cadastros for delete to authenticated using (true);

drop policy if exists "equipe exclui doacoes" on public.tui_doacoes;
create policy "equipe exclui doacoes"
  on public.tui_doacoes for delete to authenticated using (true);

-- ---------- 7) RESUMO PARA A EQUIPE (opcional) ----------
-- Crie uma view para ver totais rapidamente no SQL Editor:
create or replace view public.tui_resumo with (security_invoker = true) as
select
  (select count(*) from public.tui_cadastros)                       as total_cadastros,
  (select count(*) from public.tui_doacoes)                         as total_doacoes,
  (select coalesce(sum(quantidade),0) from public.tui_doacoes)      as itens_informados,
  (select max(criado_em) from public.tui_doacoes)                   as ultima_doacao;

-- A view também respeita o RLS: só a equipe logada vê os totais
revoke all on public.tui_resumo from anon;
grant select on public.tui_resumo to authenticated;

-- =====================================================================
-- DEPOIS DE RODAR:
-- 1) Authentication > Users > "Add user" > crie o e-mail e a senha
--    da equipe (ex.: equipe.tui@gmail.com). Marque "Auto Confirm User".
-- 2) Abra /admin.html no site e entre com esse e-mail e senha.
-- =====================================================================
