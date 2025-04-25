function CopyCode(clipboard) {
  document.querySelectorAll('.highlight').forEach((codeBlock) => {
    const button = document.createElement('button');
    button.className = 'code-copy';
    button.type = 'button';
    button.innerHTML = '<i class="fas fa-copy"></i> Copy';

    button.addEventListener('click', async () => {
      try {
        let codeText = codeBlock.textContent
          .replace(/^\s*\d+\s/gm, '') // Remove line numbers
          .replace(/^\s*|\s*$/g, ''); // Trim whitespace at top/bottom

        // Find nested <code> element
        const codeElement = codeBlock.querySelector('code');
        if (codeElement) {
          const classAttr = codeElement.getAttribute('class') || '';
          const dataLangAttr = codeElement.getAttribute('data-lang') || '';

          if (
            classAttr.includes('language-bash') ||
            classAttr.includes('language-console') ||
            dataLangAttr === 'bash' ||
            dataLangAttr === 'console'
          ) {
            codeText = codeText
              .split('\n')
              .map((line) => {
                let cleanedLine = line.trim();

                // Remove `$` (non-root) or `#` (root) command indicators
                if (/^[$#]\s?/.test(cleanedLine)) {
                  cleanedLine = cleanedLine.replace(/^[$#]\s?/, ''); // Remove `$` or `#`
                }

                // Remove inline comments that come *after* a command
                const withoutComments = cleanedLine.replace(/\s+#.*/, '');

                return withoutComments;
              })
              .filter((line) => line.trim() !== '') // Remove empty lines
              .join('\n');
          }
        } else {
          console.warn('No nested <code> element found in:', codeBlock);
        }

        await clipboard.writeText(codeText);
        button.blur(); /* Chrome fix */
        button.innerHTML = '<i class="fas fa-check"></i> Copied!';
        setTimeout(() => {
          button.innerHTML = '<i class="fas fa-copy"></i> Copy';
        }, 2000);
      } catch (error) {
        button.innerHTML = '<i class="fas fa-exclamation"></i> Error';
        console.error('Copy error:', error);
      }
    });

    codeBlock.parentNode.insertBefore(button, codeBlock);
  });
}

CopyCode(navigator.clipboard);
