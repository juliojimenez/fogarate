// Start typing-effect routines on document load
// Author: Julio Jiménez
document.addEventListener('DOMContentLoaded', function() {
  addPromptToId("whoami", "name");
  addPromptToId("projects", "ls-projects");
  addPromptToId("quotes", "quote");
  addPromptToId("random", "random-thing");
});

function typeEffect(element, text, delay = 100) {
  let i = 0; 
  const typing = setInterval(() => {
    if (i < text.length) {
      element.innerHTML += text.charAt(i);
      i++;
    } else {
      clearInterval(typing);
    }
  }, delay);
}

function randomDelay() {
  return Math.floor(Math.random() * (500 - 1) + 1);
}

function addPromptToId(id, childId) {
  const promptElement = document.createElement("div");
  promptElement.className = "prompt";
  const promptsElement = document.getElementById(id);
  promptsElement.appendChild(promptElement);
  const pElement = document.createElement("p");
  pElement.id = childId;
  promptElement.appendChild(pElement);
}
