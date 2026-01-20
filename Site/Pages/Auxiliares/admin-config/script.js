function redirectHome(){
  window.location.href = './index.html';
}
const api = '../../Admin/auth.php';
var adminPage = document.getElementById('adminPage');
var adminContent = document.getElementById('adminContent');
var twofaGate = document.getElementById('twofaGate');
var twofaGateForm = document.getElementById('twofaGateForm');
var twofaGateMsg = document.getElementById('twofaGateMsg');
var twofaForm = document.getElementById('twofaForm');
var twofaProvider = document.getElementById('twofa-provider');
var twofaEnabled = document.getElementById('twofa-enabled');
var twofaSecret = document.getElementById('twofa-secret');
var twofaCurrent = document.getElementById('twofa-current');
var twofaStatus = document.getElementById('twofaStatus');
var generateTotpBtn = document.getElementById('generateTotp');
var qrWrap = document.getElementById('qrWrap');
var qrBox = document.getElementById('qrBox');
var contactGroup = document.getElementById('contactGroup');
var contactLabel = document.getElementById('contactLabel');
var contactInput = document.getElementById('twofa-contact');
var contactHelp = document.getElementById('contactHelp');
var contactTestBtn = document.getElementById('contactTestBtn');
var secretLabel = document.getElementById('twofa-secret-label');
var secretHelp = document.getElementById('twofa-secret-help');
var secretRowElements = [generateTotpBtn, qrWrap, twofaSecret, secretLabel, secretHelp];
var loadWorksBtn = document.getElementById('loadWorksBtn');
var worksContent = document.getElementById('worksContent');
var worksStatus = document.getElementById('worksStatus');

/* =========================
   Helper: front “limpo” + console detalhado
   ========================= */
async function fetchJsonSafe(url, options, userMsg){
  var res, text = '';
  try {
    res = await fetch(url, options);
    text = await res.text();

    var json = null;
    try { json = JSON.parse(text); } catch (_) {}

    if (!res.ok) {
      console.error('[API] HTTP error', {
        url: url,
        status: res.status,
        statusText: res.statusText,
        json: json,
        responsePreview: text.slice(0, 1200)
      });
      throw new Error(userMsg || 'Falha na operação.');
    }

    if (json == null) {
      console.error('[API] Invalid JSON response', {
        url: url,
        status: res.status,
        responsePreview: text.slice(0, 1200)
      });
      throw new Error(userMsg || 'Falha na operação.');
    }

    return json;
  } catch (err) {
    console.error('[API] Request failed', { url: url, error: err });
    throw err;
  }
}

function showGate(){
  if (adminPage) adminPage.style.display = 'flex';
  if (twofaGate) twofaGate.style.display = 'block';
  if (adminContent) adminContent.style.display = 'none';
}
function showContent(){
  if (adminPage) adminPage.style.display = 'flex';
  if (twofaGate) twofaGate.style.display = 'none';
  if (adminContent) adminContent.style.display = 'block';
}

/* =========================
   Auth / 2FA (URLs absolutas)
   ========================= */
function fetchStatus(){
  return fetchJsonSafe(
    api + '?action=status',
    { method: 'GET' },
    'Sessão expirada. Faça login novamente.'
  );
}

function verifyTwofa(code){
  return fetchJsonSafe(
    api + '?action=verify2fa',
    {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'twofa=' + encodeURIComponent(code || '')
    },
    'Código 2FA inválido.'
  );
}

function loadServerConfig(){
  return fetchJsonSafe(
    api + '?action=config',
    { method: 'GET' },
    'Não foi possível carregar as configurações.'
  ).then(function(cfg){
    if (twofaProvider && cfg.provider) twofaProvider.value = cfg.provider;
    if (twofaEnabled) twofaEnabled.checked = !!cfg.enabled;
    updateProviderUI();
    return cfg;
  });
}

function saveServerConfig(){
  var payload = {
    provider: (twofaProvider && twofaProvider.value) || 'totp',
    enabled: !!(twofaEnabled && twofaEnabled.checked),
    secret: (twofaSecret && twofaSecret.value) || '',
    currentCode: (twofaCurrent && twofaCurrent.value) || '',
    contact: (contactInput && contactInput.value) || ''
  };

  return fetchJsonSafe(
    api,
    {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(payload)
    },
    'Erro ao salvar 2FA.'
  );
}

/* Boot */
fetchStatus()
  .then(function(status){
    if (!status.authenticated) {
      redirectHome();
      return;
    }
    if (!status.twofa_required || status.twofa_valid) {
      showContent();
      loadServerConfig().catch(function(){});
      return;
    }
    showGate();
  })
  .catch(function(){
    redirectHome();
  });

if (twofaGateForm) {
  twofaGateForm.addEventListener('submit', function(e){
    e.preventDefault();
    if (twofaGateMsg) twofaGateMsg.style.display = 'none';
    var code = (twofaGateForm.twofa && twofaGateForm.twofa.value) || '';
    verifyTwofa(code).then(function(){
      showContent();
      loadServerConfig().catch(function(){});
    }).catch(function(){
      if (twofaGateMsg) twofaGateMsg.style.display = 'block';
    });
  });
}

if (twofaForm) {
  twofaForm.addEventListener('submit', function(e){
    e.preventDefault();
    if (twofaStatus) twofaStatus.textContent = 'Salvando...';
    saveServerConfig().then(function(){
      if (twofaStatus) twofaStatus.textContent = 'Configuracao salva. Voce podera precisar validar o 2FA novamente.';
      if (twofaSecret) twofaSecret.value = '';
      if (twofaCurrent) twofaCurrent.value = '';
    }).catch(function(){
      if (twofaStatus) twofaStatus.textContent = 'Erro ao salvar 2FA.';
    });
  });
}

if (contactTestBtn) {
  contactTestBtn.addEventListener('click', function(){
    var provider = (twofaProvider && twofaProvider.value) || '';
    var contact = (contactInput && contactInput.value) || '';
    if (!provider || !contact) {
      if (twofaStatus) twofaStatus.textContent = 'Informe o contato antes de enviar o teste.';
      return;
    }
    twofaStatus.textContent = 'Enviando teste...';

    fetchJsonSafe(
      api + '?action=sendTest',
      {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'provider=' + encodeURIComponent(provider) + '&contact=' + encodeURIComponent(contact)
      },
      'Falha ao enviar teste.'
    ).then(function(){
      if (twofaStatus) twofaStatus.textContent = 'Codigo de teste gerado. Consulte o log ou a caixa de entrada.';
    }).catch(function(){
      if (twofaStatus) twofaStatus.textContent = 'Falha ao enviar teste.';
    });
  });
}

/* =========================
   QR / provider UI
   ========================= */
function generateRandomSecret(len){
  var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  var out = '';
  for (var i=0;i<len;i++){
    out += chars.charAt(Math.floor(Math.random()*chars.length));
  }
  return out;
}

function renderQR(data){
  if (!qrWrap || !qrBox) return;
  qrWrap.style.display = 'block';
  qrBox.innerHTML = '';
  new QRCode(qrBox, {text: data, width: 180, height: 180});
}

if (generateTotpBtn) {
  generateTotpBtn.addEventListener('click', function(){
    var secret = generateRandomSecret(16);
    if (twofaSecret) twofaSecret.value = secret;
    var label = encodeURIComponent('ConstrutoraAlianca:admin');
    var issuer = encodeURIComponent('ConstrutoraAlianca');
    var uri = 'otpauth://totp/' + label + '?secret=' + secret + '&issuer=' + issuer;
    renderQR(uri);
    if (twofaStatus) twofaStatus.textContent = 'Chave TOTP gerada. Escaneie o QR e salve as alteracoes.';
  });
}

function updateProviderUI() {
  var provider = (twofaProvider && twofaProvider.value) || 'totp';

  if (twofaProvider && twofaProvider.options) {
    Array.prototype.forEach.call(twofaProvider.options, function (opt) {
      if (opt.value === provider) opt.setAttribute('status', 'active');
      else opt.setAttribute('status', '');
    });
  }

  switch (provider) {
    case 'totp':
      if (generateTotpBtn) generateTotpBtn.style.display = 'inline-flex';
      if (qrWrap) qrWrap.style.display = (twofaSecret && twofaSecret.value) ? 'block' : 'none';
      if (contactGroup) contactGroup.style.display = 'none';
      if (secretLabel) secretLabel.textContent = 'Chave / Codigo inicial';
      if (secretHelp) secretHelp.textContent = 'Use a chave gerada ou um codigo unico.';
      if (twofaSecret) twofaSecret.placeholder = 'Ex.: codigo do app autenticador';
      secretRowElements.forEach(function(el){ if (el && el.style) el.style.display = ''; });
      break;

    case 'email':
    default:
      if (generateTotpBtn) generateTotpBtn.style.display = 'none';
      if (qrWrap) qrWrap.style.display = 'none';
      if (contactGroup) contactGroup.style.display = 'block';
      secretRowElements.forEach(function(el){ if (el && el.style) el.style.display = 'none'; });

      if (contactLabel) contactLabel.textContent = 'E-mail';
      if (contactInput) {
        contactInput.placeholder = 'email@exemplo.com';
        contactInput.type = 'email';
      }
      if (contactHelp) contactHelp.textContent = 'Informe o e-mail que receberá os códigos.';
      if (secretHelp) secretHelp.textContent = '';
      break;
  }
}

if (twofaProvider) {
  if (twofaProvider.options && twofaProvider.value) {
    var activeOpt = Array.prototype.find
      ? Array.prototype.find.call(twofaProvider.options, function (opt) {
          return opt.getAttribute('status') === 'active';
        })
      : (function () {
          for (var i = 0; i < twofaProvider.options.length; i++) {
            if (twofaProvider.options[i].getAttribute('status') === 'active') return twofaProvider.options[i];
          }
          return null;
        })();

    if (activeOpt) twofaProvider.value = activeOpt.value;
  }

  twofaProvider.addEventListener('change', function(){
    if (twofaSecret) twofaSecret.value = '';
    if (contactInput) contactInput.value = '';
    updateProviderUI();
  });

  updateProviderUI();
}

/* =========================
   Obras (list + actions)
   ========================= */
var thumbFormats = ['jpeg', 'jpg', 'png', 'webp', 'gif'];
var categoryImageDirMap = {
  'Industrias': 'Industriais'
};

function tryNextImageFormat(img, formatIndex){
  if (!formatIndex) formatIndex = 0;
  if (formatIndex >= thumbFormats.length) {
    img.style.display = 'none';
    return;
  }
  var format = thumbFormats[formatIndex];
  var basePath = img.getAttribute('data-base');
  img.src = basePath + format;
  img.setAttribute('data-format-index', formatIndex + 1);
}

function renderWorks(data){
  if (!worksContent) return;
  if (!data || !data.categories) {
    worksContent.innerHTML = '<small>Nenhuma obra encontrada.</small>';
    return;
  }
  var html = '';
  Object.keys(data.categories).forEach(function(cat){
    var list = data.categories[cat] || [];
    var imageDir = categoryImageDirMap[cat] || cat;
    html += '<div class="works-cat"><h4 style="display:flex; justify-content:space-between; align-items:center;"><span>'+cat+'</span></h4>';
    html += '<ul class="works-list'+(list.length ? '' : ' is-empty')+'" data-cat="'+cat+'">';
    list.forEach(function(item){
      var basePath = '../../../images/Obras/'+imageDir+'/'+item.slug+'/capa.';
      var imagePath = basePath + thumbFormats[0];
      html += '<li data-slug="'+item.slug+'" draggable="true">' +
        '<img class="works-thumb" src="'+imagePath+'" alt="'+item.title+'" data-base="'+basePath+'" onerror="tryNextImageFormat(this, parseInt(this.getAttribute(\'data-format-index\') || 0))">' +
        '<span>'+item.title+'</span>' +
        '<div class="works-actions">' +
        '<button type="button" class="btn-ghost" data-act="rename">Renomear</button>' +
        '<button type="button" class="btn-ghost" data-act="delete" style="color:var(--red);">Apagar</button>' +
        '</div></li>';
    });
    html += '</ul><small>'+(list.length ? 'Arraste para reordenar ou mover para outra categoria.' : 'Solte uma obra aqui para adicionar.')+'</small>';
    html += '</div>';
  });
  worksContent.innerHTML = html;
  initWorksDnD();
}

function setWorksStatus(msg, error){
  if (!worksStatus) return;
  worksStatus.style.color = error ? 'var(--red)' : 'inherit';
  worksStatus.textContent = msg || '';
}

function fetchWorks(){
  setWorksStatus('Carregando...');
  fetchJsonSafe('/Admin/obras-admin.php?action=list', { method: 'GET' }, 'Erro ao carregar obras.')
    .then(function(body){
      if (!body || !body.ok) {
        console.error('[Works] list ok=false', body);
        setWorksStatus('Falha ao carregar lista.', true);
        return;
      }
      renderWorks(body);
      setWorksStatus('Lista carregada.');
    })
    .catch(function(){
      setWorksStatus('Erro ao carregar lista.', true);
    });
}

function sendWorkAction(action, payload){
  setWorksStatus('Salvando...');
  return fetchJsonSafe(
    '/Admin/obras-admin.php?action=' + encodeURIComponent(action),
    {
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body: JSON.stringify(payload || {})
    },
    'Não foi possível salvar.'
  ).then(function(body){
    if (!body || !body.ok) {
      console.error('[Works] action ok=false', {action: action, payload: payload, body: body});
      setWorksStatus('Falha ao salvar.', true);
      throw new Error('ok=false');
    }
    setWorksStatus('Salvo.');
    return body;
  }).catch(function(err){
    console.error('[Works] sendWorkAction failed', {action: action, payload: payload, err: err});
    setWorksStatus('Erro ao salvar.', true);
    throw err;
  });
}

function handleListClick(e){
  var target = e.target;
  if (!target || !target.dataset || !target.dataset.act) return;
  var li = target.closest('li');
  var ul = target.closest('ul');
  if (!li || !ul) return;
  var slug = li.getAttribute('data-slug');
  var cat = ul.getAttribute('data-cat');
  if (!slug || !cat) return;

  var act = target.dataset.act;
  if (act === 'rename') {
    var span = li.querySelector('span');
    var currentName = span ? (span.textContent || '') : '';
    var newName = prompt('Novo nome da obra:', currentName);
    if (newName == null) return;
    newName = String(newName).trim();
    if (!newName) return;

    sendWorkAction('rename', {tipo: cat, slug: slug, name: newName})
      .then(fetchWorks)
      .catch(function(){});
    return;
  }

  if (act === 'delete') {
    if (!confirm('Apagar esta obra?')) return;
    sendWorkAction('delete', {tipo: cat, slug: slug})
      .then(fetchWorks)
      .catch(function(){});
  }
}

if (loadWorksBtn) loadWorksBtn.addEventListener('click', fetchWorks);
if (worksContent) worksContent.addEventListener('click', handleListClick);

/* =========================
   Drag & Drop (seu código)
   ========================= */
var dragState = null;
var hoverTarget = null;
var placeholder = document.createElement('li');
placeholder.className = 'drop-placeholder';
placeholder.setAttribute('draggable', 'false');
var worksDndBound = false;
var dragGhost = null;
var dragOffset = {x: 0, y: 0};

function setDragActive(on){
  if (!worksContent) return;
  var lists = worksContent.querySelectorAll('.works-list');
  for (var i = 0; i < lists.length; i++) {
    if (on) lists[i].classList.add('drag-active');
    else lists[i].classList.remove('drag-active');
  }
}

function setPlaceholderHeightFrom(li){
  placeholder.style.height = '12px';
}

function destroyGhost(){
  if (dragGhost && dragGhost.parentNode) dragGhost.parentNode.removeChild(dragGhost);
  dragGhost = null;
}

function updateGhostPosition(e){
  if (!dragGhost || e == null) return;
  var x = (e.clientX || 0) - (dragOffset.x || 0) + 6;
  var y = (e.clientY || 0) - (dragOffset.y || 0) + 6;
  dragGhost.style.transform = 'translate(' + x + 'px,' + y + 'px)';
}

function createGhost(li, e){
  destroyGhost();
  if (!li) return;
  var rect = li.getBoundingClientRect();
  dragOffset.x = e ? (e.clientX - rect.left) : rect.width / 2;
  dragOffset.y = e ? (e.clientY - rect.top) : rect.height / 2;
  var g = li.cloneNode(true);
  g.classList.add('dragging');
  g.style.position = 'fixed';
  g.style.pointerEvents = 'none';
  g.style.left = '0';
  g.style.top = '0';
  g.style.margin = '0';
  g.style.width = rect.width + 'px';
  g.style.zIndex = '9999';
  g.style.opacity = '0.92';
  g.classList.add('drag-ghost');
  document.body.appendChild(g);
  dragGhost = g;
  updateGhostPosition(e);
}

function cleanPlaceholder(){
  if (placeholder.parentNode) placeholder.parentNode.removeChild(placeholder);
}

function computeOrder(ul){
  var order = [];
  if (!ul) return order;
  var els = ul.querySelectorAll('li[data-slug]');
  for (var i = 0; i < els.length; i++) order.push(els[i].getAttribute('data-slug'));
  return order;
}

function handleDragStart(e){
  var li = e.target.closest('li[draggable]');
  if (!li) return;
  var ul = li.closest('.works-list');
  if (!ul) return;

  dragState = {
    slug: li.getAttribute('data-slug'),
    cat: ul.getAttribute('data-cat'),
    li: li,
    sourceUl: ul,
    mode: 'html5'
  };

  setPlaceholderHeightFrom(li);
  ul.insertBefore(placeholder, li);
  li.classList.add('dragging');
  createGhost(li, e);
  setDragActive(true);

  if (e.dataTransfer) {
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/plain', dragState.slug || '');
  }
}

function findTargetList(e){
  var ul = e.target.closest('.works-list');
  if (!ul && placeholder.parentNode && placeholder.parentNode.classList && placeholder.parentNode.classList.contains('works-list')) {
    ul = placeholder.parentNode;
  }
  return ul;
}

function getAfterElement(ul, y){
  var candidates = ul.querySelectorAll('li[data-slug]:not(.dragging)');
  for (var i = 0; i < candidates.length; i++) {
    var item = candidates[i];
    if (item === placeholder) continue;
    var rect = item.getBoundingClientRect();
    if (y < rect.top + rect.height / 2) return item;
  }
  return null;
}

function handleDragOver(e){
  if (!dragState) return;
  var ul = findTargetList(e);
  if (!ul) return;
  e.preventDefault();
  if (e.dataTransfer) e.dataTransfer.dropEffect = 'move';

  var after = getAfterElement(ul, e.clientY);
  updateGhostPosition(e);

  if (hoverTarget && hoverTarget !== after) hoverTarget.classList.remove('drag-over');
  if (after) {
    hoverTarget = after;
    after.classList.add('drag-over');
    ul.insertBefore(placeholder, after);
  } else {
    hoverTarget = null;
    ul.appendChild(placeholder);
  }
}

function handleDrop(e){
  if (!dragState) return;
  e.preventDefault();

  var targetUl = findTargetList(e) || dragState.sourceUl;
  var sourceUl = dragState.sourceUl;
  var sourceCat = dragState.cat;
  var slug = dragState.slug;

  if (hoverTarget) hoverTarget.classList.remove('drag-over');

  if (!targetUl || !slug) {
    cancelDrag();
    return;
  }

  if (placeholder.parentNode !== targetUl) targetUl.appendChild(placeholder);
  targetUl.insertBefore(dragState.li, placeholder);
  cleanPlaceholder();
  dragState.li.classList.remove('dragging');
  destroyGhost();

  if (!targetUl.querySelector('li[data-slug]')) targetUl.classList.add('is-empty');
  else targetUl.classList.remove('is-empty');
  if (sourceUl && !sourceUl.querySelector('li[data-slug]')) sourceUl.classList.add('is-empty');

  var targetCat = targetUl.getAttribute('data-cat');
  var sourceOrder = computeOrder(sourceUl);
  var targetOrder = computeOrder(targetUl);

  if (targetCat === sourceCat) {
    sendWorkAction('reorder', { tipo: targetCat, order: targetOrder }).catch(function(){});
  } else {
    sendWorkAction('move', { tipo: sourceCat, from: sourceCat, to: targetCat, slug: slug })
      .then(function(){
        if (sourceOrder.length) return sendWorkAction('reorder', { tipo: sourceCat, order: sourceOrder });
      })
      .then(function(){
        if (targetOrder.length) return sendWorkAction('reorder', { tipo: targetCat, order: targetOrder });
      })
      .then(fetchWorks)
      .catch(function(){});
  }

  dragState = null;
  hoverTarget = null;
  setDragActive(false);
}

function cancelDrag(){
  if (!dragState) return;
  if (placeholder.parentNode && dragState.li) {
    placeholder.parentNode.insertBefore(dragState.li, placeholder);
    cleanPlaceholder();
  } else if (dragState.sourceUl && dragState.li && !dragState.li.parentNode) {
    dragState.sourceUl.appendChild(dragState.li);
  }
  if (dragState.li) dragState.li.classList.remove('dragging');
  if (hoverTarget) hoverTarget.classList.remove('drag-over');
  destroyGhost();
  hoverTarget = null;
  dragState = null;
  setDragActive(false);
}

function handleDragEnd(){
  cancelDrag();
}

function locateListFromPoint(e){
  var el = document.elementFromPoint(e.clientX, e.clientY);
  return el ? el.closest('.works-list') : null;
}

function startPointerDrag(e){
  if (e.button !== 0) return;
  var li = e.target.closest ? e.target.closest('.works-list li') : null;
  if (!li || (e.target.closest && e.target.closest('.works-actions'))) return;
  var ul = li.closest('.works-list');
  if (!ul) return;

  dragState = {
    slug: li.getAttribute('data-slug'),
    cat: ul.getAttribute('data-cat'),
    li: li,
    sourceUl: ul,
    mode: 'pointer',
    pointerId: e.pointerId
  };

  if (li.setPointerCapture) {
    try { li.setPointerCapture(e.pointerId); } catch(err){}
  }

  setPlaceholderHeightFrom(li);
  ul.insertBefore(placeholder, li);
  li.classList.add('dragging');
  createGhost(li, e);
  setDragActive(true);
  e.preventDefault();
}

function movePointerDrag(e){
  if (!dragState || dragState.mode !== 'pointer') return;
  if (dragState.pointerId != null && e.pointerId !== dragState.pointerId) return;
  var ul = locateListFromPoint(e) || dragState.sourceUl;
  if (!ul) return;
  e.preventDefault();
  var after = getAfterElement(ul, e.clientY);
  updateGhostPosition(e);
  if (hoverTarget && hoverTarget !== after) hoverTarget.classList.remove('drag-over');
  if (after) {
    hoverTarget = after;
    after.classList.add('drag-over');
    ul.insertBefore(placeholder, after);
  } else {
    hoverTarget = null;
    ul.appendChild(placeholder);
  }
}

function endPointerDrag(e){
  if (!dragState || dragState.mode !== 'pointer') return;
  if (dragState.pointerId != null && e.pointerId !== dragState.pointerId) return;
  e.preventDefault();

  var ul = locateListFromPoint(e) || dragState.sourceUl;
  var sourceUl = dragState.sourceUl;
  var sourceCat = dragState.cat;
  var slug = dragState.slug;

  if (hoverTarget) hoverTarget.classList.remove('drag-over');

  if (!ul || !slug) {
    cancelDrag();
    return;
  }

  if (placeholder.parentNode !== ul) ul.appendChild(placeholder);
  ul.insertBefore(dragState.li, placeholder);
  cleanPlaceholder();
  dragState.li.classList.remove('dragging');
  destroyGhost();

  if (!ul.querySelector('li[data-slug]')) ul.classList.add('is-empty');
  else ul.classList.remove('is-empty');
  if (sourceUl && !sourceUl.querySelector('li[data-slug]')) sourceUl.classList.add('is-empty');

  var targetCat = ul.getAttribute('data-cat');
  var sourceOrder = computeOrder(sourceUl);
  var targetOrder = computeOrder(ul);

  if (targetCat === sourceCat) {
    sendWorkAction('reorder', { tipo: targetCat, order: targetOrder }).catch(function(){});
  } else {
    sendWorkAction('move', { tipo: sourceCat, from: sourceCat, to: targetCat, slug: slug })
      .then(function(){
        if (sourceOrder.length) return sendWorkAction('reorder', { tipo: sourceCat, order: sourceOrder });
      })
      .then(function(){
        if (targetOrder.length) return sendWorkAction('reorder', { tipo: targetCat, order: targetOrder });
      })
      .then(fetchWorks)
      .catch(function(){});
  }

  dragState = null;
  hoverTarget = null;
  setDragActive(false);
}

function initWorksDnD(){
  dragState = null;
  hoverTarget = null;
  cleanPlaceholder();
  if (!worksContent) return;

  var items = worksContent.querySelectorAll('.works-list li');
  for (var i = 0; i < items.length; i++) {
    items[i].setAttribute('draggable', 'true');
    items[i].draggable = true;
    items[i].removeEventListener('dragstart', handleDragStart);
    items[i].removeEventListener('dragend', handleDragEnd);
    items[i].addEventListener('dragstart', handleDragStart);
    items[i].addEventListener('dragend', handleDragEnd);
    items[i].removeEventListener('pointerdown', startPointerDrag);
    items[i].addEventListener('pointerdown', startPointerDrag);
  }

  var lists = worksContent.querySelectorAll('.works-list');
  for (var j = 0; j < lists.length; j++) {
    var ul = lists[j];
    if (ul.querySelector('li[data-slug]')) ul.classList.remove('is-empty');
    else ul.classList.add('is-empty');

    ul.removeEventListener('dragover', handleDragOver);
    ul.removeEventListener('dragenter', handleDragOver);
    ul.removeEventListener('drop', handleDrop);

    ul.addEventListener('dragover', handleDragOver);
    ul.addEventListener('dragenter', handleDragOver);
    ul.addEventListener('drop', handleDrop);
  }

  if (!worksDndBound) {
    worksContent.addEventListener('dragstart', handleDragStart, true);
    worksContent.addEventListener('dragover', handleDragOver);
    worksContent.addEventListener('dragenter', handleDragOver);
    worksContent.addEventListener('drop', handleDrop);
    worksContent.addEventListener('dragend', handleDragEnd);

    worksContent.addEventListener('mousedown', function(ev){
      var li = ev.target && ev.target.closest ? ev.target.closest('.works-list li') : null;
      if (li) li.draggable = true;
    });

    document.addEventListener('pointermove', movePointerDrag);
    document.addEventListener('pointerup', endPointerDrag);
    document.addEventListener('pointercancel', endPointerDrag);
    worksDndBound = true;
  }
}
