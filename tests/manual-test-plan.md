# Plano de Testes (Manual) – Admin Obras e Vitrine

## Pré‑requisitos
- PHP com sessões habilitadas, extensões padrão e permissão de escrita em `Site/data`, `Site/images/Obras/*` e `Site/Pages/*`.
- Navegador com cookies habilitados.
- Usuário e senha válidos configurados no backend (`Admin/auth.php`).

## Fluxos de Autenticação
1) **Login sem 2FA ativo**
   - Acessar modal admin no site público, fazer login com credenciais válidas.
   - Esperado: redireciona para `admin-obra.html` sem exigir código; `Admin/obras-admin.php?action=list` responde 200.
2) **Login com 2FA ativo (totp ou email)**
   - Ativar 2FA em `admin-config.html`, salvar.
   - Fazer logout (limpar sessão), login novamente.
   - Esperado: página mostra gate 2FA; ao inserir código válido, destrava admin; código inválido deve negar.
3) **Sessão expirada**
   - Após login, expirar sessão (limpar cookies ou aguardar timeout), tentar carregar lista de obras.
   - Esperado: backend responde 401/redirect para login; UI volta ao gate.

## CRUD e Ordenação de Obras
4) **Listagem inicial**
   - Em `admin-config.html`, clicar “Carregar lista”.
   - Esperado: categorias renderizadas conforme `images/Obras/*` e ordem de `data/obras-order.json`.
5) **Reordenar na mesma categoria**
   - Arrastar item dentro da mesma lista.
   - Esperado: ordem persiste após refresh; vitrine pública (ex.: `Pages/Auxiliares/Casas.php`) reflete nova ordem.
6) **Mover entre categorias não vazias**
   - Arrastar obra de Casas para Industrias.
   - Esperado: pasta e HTML da obra são movidos para `images/Obras/Industriais` e `Pages/Industrias`; some de Casas, aparece em Industrias, ordem salva no JSON.
7) **Mover para categoria vazia**
   - Garantir categoria vazia (ex.: criar dummy em Outra categoria, remover tudo), arrastar obra para a lista vazia.
   - Esperado: placeholder aparece dentro da lista vazia; obra é aceita, lista deixa de ser “is-empty”.
8) **Rename**
   - Renomear obra; slug muda sem duplicar; ordem do JSON é atualizada; página pública abre com novo título.
9) **Delete**
   - Apagar obra; pasta de imagens e HTML são removidos; item some da UI e das vitrines.

## Geração/Consistência de Páginas
10) **Gerar página ao detectar pasta nova**
    - Criar pasta nova em `images/Obras/Casas/NovaObra` com imagens; clicar “Carregar lista”.
    - Esperado: página `Pages/Casas/NovaObra.html` gerada; capa escolhida com “capa” no nome se existir.
11) **Capa obrigatória**
    - Pasta sem “capa” mas com imagens: capa deve ser a primeira imagem; sem imagens: obra ignorada.

## Segurança
12) **Sem sessão admin**
   - Chamar `Admin/obras-admin.php?action=list` sem login.
    - Esperado: 401/erro “unauthorized”.
13) **2FA exigido**
    - Com 2FA ativo e `twofa_valid` ausente, chamar `Admin/obras-admin.php?action=list`.
    - Esperado: 401/erro “unauthorized”.
14) **Sem token HTML**
    - Confirmar que chamadas não dependem de cabeçalho cliente; apenas sessão backend.

## UI/UX Drag and Drop
15) **Ghost segue cursor**
    - Arrastar item; ghost acompanha o mouse e placeholder não deixa “buraco”.
16) **Placeholder compacto**
    - Arrastar em lista curta; placeholder fino visível, sem ocupar altura de item.
17) **Categorias vazias estilizadas**
    - Lista vazia exibe borda tracejada e fundo claro; ao receber item, remove estilo “is-empty”.

## Regressão Visual Vitrine
18) **Ordem refletida**
    - Após reordenar/mover, verificar vitrine das categorias (Casas, Industrias, Predios, Outros) e conferir ordem = `data/obras-order.json`.
19) **Links corretos**
    - Clicar nas capas; deve abrir página HTML movida/gerada no destino certo.

## Logs/Erros
20) **Erros de gravação**
    - Simular permissão negada (tornar data/ read-only) e tentar reordenar.
    - Esperado: status de erro exibido no admin; nada é corrompido.

## Limpeza
21) **Restaurar estado**
    - Reverter alterações manuais de teste (apagar dummies, restaurar ordem desejada).
