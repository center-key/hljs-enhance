// hljs-enhance - https://github.com/center-key/hljs-enhance - MIT License

const hljsEnhance = {

   setup() {
      // <figure class=hljs-enhance>
      //    <figcaption>Title</figcaption>
      //    <pre><code class="language-javascript hljs hljs-done>
      //       ...
      const init = (elem) => {
         const indent =     '   ';
         const padding =    new RegExp(elem.textContent.match(/\n[ \t]+/), 'g');
         elem.textContent = elem.textContent.replace(padding, '\n').replace(/\t/g, indent).trim();
         elem.parentElement.classList.add('hljs-enhance');
         elem.closest('figure')?.classList.add('hljs-enhance');
         globalThis.hljs.highlightElement(elem);
         elem.classList.add('hljs-done');
         };
      globalThis.document.querySelectorAll('pre code:not(.hljs-done)').forEach(init);
      globalThis.document.querySelectorAll('figure.hljs-enhance >div')
         .forEach(elem => elem.classList.add('hljs'));  //trim boxes without code
      },

   onDomReady(callback) {
      const state = globalThis.document?.readyState;
      if (state === 'complete' || !state)
         callback();
      else
         globalThis.window.addEventListener('DOMContentLoaded', callback);
      return state;
      },

   };

globalThis.hljsEnhance = hljsEnhance;
hljsEnhance.onDomReady(hljsEnhance.setup);
