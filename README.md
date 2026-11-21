# Guia TypeScript

Site: https://wallysondevs.github.io/guia-typescript/

Curso de TypeScript em português, do zero ao avançado, feito para quem **já viu o básico de JavaScript** (variáveis, `if`, funções, arrays e objetos). Se você ainda não viu, comece pelo [Guia JavaScript](https://wallysondevs.github.io/guia-js/) e volte depois. Funciona como uma escola: uma aula para cada assunto, organizadas em **3 níveis** (41 páginas). O curso começa em tipos e funções e chega a interfaces, classes, generics, utility types, mapped e conditional types, arquivos `.d.ts`, decorators e TypeScript com Node.

- **Nível 1 · Iniciante** (15 páginas): começando, tipos básicos, funções, objetos e combinando tipos.
- **Nível 2 · Intermediário** (13 páginas): classes, generics, ferramentas de tipo e o projeto em si (módulos, `tsconfig.json` e `async`/`await`).
- **Nível 3 · Avançado** (13 páginas): tipos avançados, ecossistema e organização, com um projeto final (lista de tarefas).

Cada aula explica o código parte por parte, mostra a saída real e o que acontece quando dá errado, com a mensagem verdadeira do compilador (como `TS2322`). No fim vêm exercícios e perguntas de múltipla escolha. Todas as saídas foram colhidas com o **TypeScript 7.0.2** e o **Node.js 24.22.1**, num projeto criado com `npx tsc --init`. Com outras versões, o texto de algumas mensagens pode mudar um pouco, mas o código do erro costuma ser o mesmo. Os exemplos acompanham a Ana, num computador fictício chamado `notebook`, com o projeto na pasta `/home/ana/projeto`.

Para praticar, as páginas trazem **88 missões** no modo **"Rode no seu terminal"** (`.trycmd`). Não há simulador: você usa o seu próprio TypeScript.

1. Leia a missão e clique em **Copiar código** (o arquivo é `src/missao.ts`).
2. Rode no seu terminal com `npx tsc && node dist/missao.js` (ou o comando que a missão pedir).
3. Cole a saída na caixa e clique em **Conferir**: a caixa diz se você chegou ao resultado pedido.
4. Depois do primeiro **Conferir**, o botão **Ver solução** é liberado.

A caixa é montada por `assets/rode-local.js`. O código e a saída colada ficam só na página: nada é enviado nem guardado no navegador.

Site 100% estático (HTML + CSS + JS, sem build e sem dependências externas): abre direto no navegador e funciona no GitHub Pages.

## Estrutura

```
index.html                 página inicial
<tema>.html                uma aula por tema
assets/style.css           visual
assets/site.js             níveis/menu (lista NIVEIS), Anterior/Próximo, exercícios
assets/rode-local.js       a caixa "Rode no seu terminal" (.trycmd)
assets/rode-local.css      visual da caixa
tools/testar-missoes.js    testa as missões com o mesmo avaliador da página e a saída real guardada
tools/testar-navegador.js  abre as páginas num Chrome sem janela e confere as caixas
tools/checar-privacidade.sh  procura dados de máquina real nas páginas e no histórico
.nojekyll                  faz o GitHub Pages servir os arquivos como estão
```

## Testes

```bash
node tools/testar-missoes.js                 # todas as missões
node tools/testar-missoes.js --secao "Começando"   # só uma seção do menu
node tools/testar-navegador.js --todas       # todas as páginas num Chrome sem janela (precisa do puppeteer-core em tools/node_modules)
bash tools/checar-privacidade.sh             # privacidade: rode antes de todo commit
```

## Publicar no GitHub Pages

Envie a pasta para um repositório e ative **Settings → Pages → Deploy from a branch → main / (root)**.

## Adicionar uma aula

Copie uma aula existente como modelo, inclua a página na lista `NIVEIS` de `assets/site.js` e rode `node tools/testar-missoes.js` e `bash tools/checar-privacidade.sh` antes do commit.
