// Tightly coupled to `render-codeblock.html` for element targeting
const copyToClipBoard = ((clipboard) => async (button, codeBlockId) => {
  const codeBlock = document
    .getElementById(codeBlockId)
    .getElementsByClassName('highlight')[0];

  if (!codeBlock) {
    console.error('No code block found to copy from.');
    button.innerHTML = 'Error';
    return;
  }

  const cleanCode = codeBlock.textContent
    .replace(/^\s*\d+\s/gm, '') // Remove line numbers
    .trim();

  try {
    await clipboard.writeText(cleanCode);

    updateButtonState(button, 'Copied!', 2000, true);
  } catch (error) {
    updateButtonState(button, 'Error');
    console.error(error);
  }
})(navigator.clipboard);

const updateButtonState = (button, message, revertDelay, disable = false) => {
  button.innerHTML = message;

  if (disable) {
    button.disabled = true;
  }

  if (revertDelay) {
    setTimeout(() => {
      button.innerHTML = 'Copy';
      button.disabled = false;
    }, revertDelay);
  }
};
