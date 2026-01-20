const api = '../../Admin/auth.php';

function redirectHome(){
    window.location.href = './index.html';
}


function ensureFrontToken(){
    try{
        var payload = { ts: Date.now(), ua: navigator.userAgent };
        sessionStorage.setItem('adminToken', btoa(JSON.stringify(payload)));
    }catch(err){}
}

var adminPage = document.getElementById('adminPage');
var adminContent = document.getElementById('adminContent');
var twofaGate = document.getElementById('twofaGate');
var twofaGateForm = document.getElementById('twofaGateForm');
var twofaGateMsg = document.getElementById('twofaGateMsg');

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

function fetchStatus(){
    return fetch(api + '?action=status').then(function(res){
        if (!res.ok) throw new Error('auth');
        return res.json();
    });
}

function verifyTwofa(code){
    var body = 'twofa=' + encodeURIComponent(code || '');
    return fetch(api + '?action=verify2fa', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body
    }).then(function(res){
        if (!res.ok) throw new Error('invalid');
        return res.json();
    });
}

fetchStatus()
    .then(function(status){
        if (!status.authenticated) {
            redirectHome();
            return;
        }
        if (!status.twofa_required || status.twofa_valid) {
            //alert(status.twofa_required + ' and ' + status.twofa_valid);
            showContent();
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
        }).catch(function(){
            if (twofaGateMsg) twofaGateMsg.style.display = 'block';
        });
    });
}

const obraForm = document.getElementById('obraForm');
const obraStatus = document.getElementById('obraStatus');
const nomeInput = document.getElementById('nome');
const tipoSelect = document.getElementById('tipo');
const fotosInput = document.getElementById('fotos');
const configLink = document.getElementById('configLink');
let sending = false;
if (configLink) {
    configLink.addEventListener('click', function(e){
        e.preventDefault();
        ensureFrontToken();
        fetch(api + '?action=status', { credentials: 'include' })
            .finally(function(){
                window.location.href = configLink.getAttribute('href');
            });
    });
}

function setStatus(msg, isError, allowHtml){
    if (!obraStatus) return;
    obraStatus.style.color = isError ? 'var(--red)' : 'inherit';
    if (allowHtml) {
        obraStatus.innerHTML = msg || '';
    } else {
        obraStatus.textContent = msg || '';
    }
}


if (obraForm) {
    obraForm.addEventListener('submit', function(e){
        e.preventDefault();
        if (sending) return;

        const files = fotosInput && fotosInput.files ? fotosInput.files.length : 0;
        if (!files) {
            setStatus('Envie ao menos uma foto.', true);
            return;
        }
        if (files > 32) {
            setStatus('Limite de 32 fotos por obra.', true);
            return;
        }
        const nome = nomeInput ? nomeInput.value.trim() : '';
        if (!nome) {
            setStatus('Informe o nome da obra.', true);
            return;
        }

        const fd = new FormData();
        fd.append('tipo', tipoSelect ? (tipoSelect.value || '') : '');
        fd.append('nome', nome);
        for (var i = 0; i < (fotosInput.files ? fotosInput.files.length : 0); i++) {
            fd.append('fotos[]', fotosInput.files[i]);
        }
        sending = true;
        setStatus('Enviando e publicando...');

        fetch(api, {
            method: 'POST',
            body: fd
        }).then(function(res){
            return res.json().then(function(j){ return { ok: res.ok, body: j }; });
        }).then(function(resp){
            sending = false;
            if (!resp.ok || !resp.body || !resp.body.ok) {
                const msg = (resp.body && resp.body.error) ? resp.body.error : 'Falha ao salvar obra.';
                setStatus('Erro: ' + msg, true);
                return;
            }
            var linkHtml = resp.body.page ? ' <a href=\"../../../' + resp.body.page + '\" target=\"_blank\">Ver pagina</a>' : '';
            setStatus('Obra publicada com sucesso!' + linkHtml, false, true);
            if (obraForm) obraForm.reset();
        }).catch(function(){
            sending = false;
            setStatus('Erro ao conectar. Tente novamente.', true);
        });
    });
}