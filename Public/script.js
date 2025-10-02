const ws = new WebSocket('wss://localhost:8443/chat');
const messages = document.getElementById('messages');
const messageInput = document.getElementById('messageInput');
const sendButton = document.getElementById('sendButton');
const userInfo = document.getElementById('userInfo');

let myEmoji = '';
let myColor = '';
let myName = '';

ws.onopen = function() {
    addSystemMessage('✅ WebSocket 연결됨!');
};

ws.onmessage = function(event) {
    try {
        const data = JSON.parse(event.data);
        
        if (data.type === 'welcome') {
            myEmoji = data.emoji;
            myColor = data.color;
            myName = data.name;
            userInfo.innerHTML = `<span class="emoji">${myEmoji}</span> <span style="color: ${myColor};">${myName}</span>`;
            addSystemMessage(`환영합니다! 당신은 ${myEmoji} ${myName} 입니다.`);
        } else if (data.type === 'message') {
            addChatMessage(data);
        }
    } catch (e) {
        console.error('Error parsing message:', e);
    }
};

ws.onclose = function() {
    addSystemMessage('❌ WebSocket 연결 끊어짐');
};

function addSystemMessage(message) {
    const div = document.createElement('div');
    div.className = 'system-message';
    div.textContent = message;
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
}

function addChatMessage(data) {
    const div = document.createElement('div');
    div.className = data.isSelf ? 'message self' : 'message other';
    div.style.background = data.isSelf ? '#DCF8C6' : data.color + '20';
    div.style.borderLeft = data.isSelf ? 'none' : `4px solid ${data.color}`;
    
    const header = document.createElement('div');
    header.className = 'message-header';
    header.style.color = data.color;
    header.innerHTML = `<span class="emoji">${data.emoji}</span> <span>${data.name}</span>`;
    
    const text = document.createElement('div');
    text.className = 'message-text';
    text.textContent = data.text;
    
    div.appendChild(header);
    div.appendChild(text);
    messages.appendChild(div);
    
    // Clear float
    const clearDiv = document.createElement('div');
    clearDiv.style.clear = 'both';
    messages.appendChild(clearDiv);
    
    messages.scrollTop = messages.scrollHeight;
}

function sendMessage() {
    const message = messageInput.value.trim();
    if (message && ws.readyState === WebSocket.OPEN) {
        ws.send(message);
        messageInput.value = '';
    }
}

sendButton.onclick = sendMessage;
messageInput.onkeypress = function(e) {
    if (e.key === 'Enter') {
        sendMessage();
    }
};
