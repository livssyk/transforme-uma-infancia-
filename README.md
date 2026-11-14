# 🧸 Transforme Uma Infância — T.U.I.

Site da campanha **T.U.I.** (ODS 1) com formulários que gravam as informações em um **banco de dados online gratuito** (Supabase), funcionando no **GitHub Pages**.

---

## 📁 Arquivos

| Arquivo | Para que serve |
|---|---|
| `index.html` | O site (página inicial, ODS 1, como funciona, formulários, contatos) |
| `admin.html` | **Área da equipe**: login, lista de doações e cadastros, busca, exportar CSV, excluir |
| `config.js` | ⚙️ **Único arquivo que você edita**: chave do banco + WhatsApp/e-mail |
| `supabase.sql` | Script que cria as tabelas e as regras de segurança (roda 1 vez só) |
| `README.md` | Este guia |

---

## 🚀 Passo 1 — Criar o banco de dados online (Supabase)

O Supabase é um banco PostgreSQL na nuvem com plano gratuito (sem cartão de crédito).

1. Acesse **https://supabase.com** → **Start your project** → entre com sua conta Google/GitHub.
2. Clique em **New project**:
   - **Name:** `tui-doacoes`
   - **Database Password:** crie uma senha forte e **guarde** (não é usada pelo site)
   - **Region:** `South America (São Paulo)` — mais rápido para o Brasil
   - Clique em **Create new project** e espere ~2 minutos.
3. No menu esquerdo, abra **SQL Editor** → **New query**.
4. Abra o arquivo `supabase.sql`, copie **todo** o conteúdo, cole no editor e clique em **Run** (ou `Ctrl+Enter`).
   - Deve aparecer *"Success. No rows returned"*.
   - Isso cria as tabelas `tui_doacoes` e `tui_cadastros`, com segurança ativada.
5. Pegue as duas informações que o site precisa:
   - Menu **Project Settings** (engrenagem) → **API** (ou *API Keys*)
   - Copie **Project URL** → ex.: `https://abcdefghij.supabase.co`
   - Copie a chave **`anon` / `public`** (a chave longa que começa com `eyJ...` ou `sb_publishable_...`)

> ⚠️ Use **somente** a chave `anon`/`public` no site. A chave `service_role` é secreta e **nunca** deve ir para o GitHub.

---

## ⚙️ Passo 2 — Preencher o `config.js`

Abra `config.js` (no GitHub, clique no arquivo → ícone de lápis ✏️) e troque:

```js
supabaseUrl: "COLE_AQUI_A_URL_DO_PROJETO",       // ex.: "https://abcdefghij.supabase.co"
supabaseAnonKey: "COLE_AQUI_A_CHAVE_ANON_PUBLICA", // a chave anon/public
whatsapp: "5511968293336",                        // só números: 55 + DDD + número
email: "projeto.transformeumainfancia@gmail.com",
```

Clique em **Commit changes**. Em ~1 minuto o site já está salvando online.

Enquanto esses campos estiverem como `COLE_AQUI...`, o site continua funcionando em **modo local** (salva só no navegador do visitante) e mostra um aviso no formulário.

---

## 👤 Passo 3 — Criar o login da equipe (para ver os dados)

1. No Supabase: **Authentication** → **Users** → **Add user** → **Create new user**.
2. E-mail: ex. `equipe.tui@gmail.com` • Senha: uma senha forte.
3. Marque **Auto Confirm User** (senão o login não funciona).
4. Acesse **`seu-site/admin.html`** (ou clique em *Área da equipe* no rodapé do site) e entre com esse e-mail e senha.

Lá você vê **todas as doações e cadastros**, pode **buscar**, **exportar CSV** (abre no Excel/Google Planilhas) e **excluir** registros.

> Os dados também ficam visíveis no painel do Supabase em **Table Editor** → `tui_doacoes` / `tui_cadastros`.

---

## 🌐 Passo 4 — Publicar no GitHub Pages

### Opção A — Pelo site do GitHub (sem instalar nada)
1. Crie um repositório novo (ex.: `transforme-uma-infancia`), pode ser **Public**.
2. Envie os arquivos: **Add file** → **Upload files** → arraste `index.html`, `admin.html`, `config.js`, `supabase.sql`, `README.md` → **Commit changes**.
3. Vá em **Settings** → **Pages** (menu lateral).
4. Em **Source**, escolha **Deploy from a branch**; **Branch:** `main` e pasta **`/ (root)`** → **Save**.
5. Em 1–2 minutos o site fica em:
   `https://SEU-USUARIO.github.io/transforme-uma-infancia/`
   e o painel em `https://SEU-USUARIO.github.io/transforme-uma-infancia/admin.html`

### Opção B — Pelo terminal (Git)
```bash
git init
git add .
git commit -m "T.U.I. com banco online"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/transforme-uma-infancia.git
git push -u origin main
```
Depois siga do item 3 da Opção A (Settings → Pages).

> Dica: para usar um domínio próprio depois, é só em **Settings → Pages → Custom domain**.
> Se quiser que a área da equipe não seja indexada pelo Google, já deixamos `noindex` no `admin.html`.

---

## 🔄 Como o fluxo funciona hoje

**Doador(a) preenche o formulário** → os dados vão para o banco online **e** abrem o WhatsApp com a mensagem pronta (para combinar a entrega). Se a internet falhar, o site avisa e salva uma cópia no navegador, sem perder o registro.

**Itens disponíveis no formulário de doação:**
🧸 Brinquedos novos • 🪀 Brinquedos usados em bom estado • 📚 Livros infantis • 🧩 Jogos/atividades • 👶 Fraldas descartáveis • 🍼 Mamadeiras • 🧷 Chupetas • 🧼 Produtos de higiene básica • 🧴 Itens de cuidados infantis

Ao marcar *Fraldas descartáveis*, aparece um campo opcional de tamanho (RN, P, M, G...).

---

## 🔒 Privacidade e segurança (importante)

- **Visitantes não conseguem ler os dados.** As regras do banco permitem apenas *inserir* (anon). Ler e excluir é exclusivo de quem está **logado** (`authenticated`).
- Não coletamos CPF, endereço nem dados de crianças — só nome, contato e itens doados.
- Vale incluir na campanha um aviso simples: *"Os dados informados são usados apenas para organizar as doações da campanha T.U.I."* (LGPD, art. 7º — consentimento).
- Se quiser apagar tudo no fim da campanha: **Table Editor** → selecione as linhas → *Delete rows*, ou rode no SQL Editor:
  ```sql
  truncate table public.tui_doacoes;
  truncate table public.tui_cadastros;
  ```

---

## 🧪 Como testar depois de configurar

1. Abra o site publicado e faça uma doação de teste (marque 2 itens).
2. Se aparecer *"✅ Intenção registrada na base online!"* está funcionando.
3. Abra `admin.html`, entre com o e-mail da equipe e confira o registro.
4. Depois **exclua o teste** pelo botão *Excluir*.

---

## 🛠️ Problemas comuns

| Sintoma | Causa provável | Solução |
|---|---|---|
| Aviso amarelo "Modo local" no formulário | `config.js` ainda com `COLE_AQUI` | Preencha a URL e a chave `anon` |
| "Erro 401" ou "new row violates row-level security policy" | O `supabase.sql` não foi executado | Rode o script completo no SQL Editor |
| "E-mail ou senha inválidos" no `admin.html` | Usuário não confirmado | Authentication → Users → confirme o e-mail (ou crie com *Auto Confirm User*) |
| Site abriu, mas em branco | `config.js` com vírgula/aspas faltando | Confira o arquivo (mantenha as aspas e as vírgulas) |
| Não aparece o botão do WhatsApp | Bloqueador de pop-up | Permita pop-ups no site |
| Mudou algo e o site não atualiza | Cache do GitHub Pages | Espere 2 min e recarregue com `Ctrl+F5` |

---

## 📌 O que foi ajustado nesta versão

- **Brinquedos** e itens de **cuidado infantil** (fraldas, mamadeiras, chupetas, higiene) agora estão no formulário.
- **Número do WhatsApp unificado** — o site mostrava um número e o botão abria outro. Agora há uma única fonte (no `config.js`) e a mensagem da doação vai para o número certo.
- **Menu mobile** funcionando (antes os links desapareciam em telas pequenas).
- **Link "Destino"** adicionado ao menu (a seção existia, mas não era acessível pelo menu).
- **Cadastro salvo online** (antes só no navegador), com campo de WhatsApp opcional.
- **Mensagens de sucesso/erro** dentro do formulário, validação de nome/e-mail, botões com estado "Enviando...", e formulário limpo após o envio.
- **Área da equipe** (`admin.html`) com login, busca, exportação CSV e exclusão.
- Pequenos ajustes de acessibilidade (foco nos campos, `aria-live`, favicon 🧸) e SEO (descrição atualizada).
