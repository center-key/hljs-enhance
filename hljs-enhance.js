// hljs-enhance - https://github.com/center-key/hljs-enhance - MIT License
const hljsEnhance = {
   setup() {
      const init = (i, elem) => {
         elem = $(elem);
         const indent = '   ';
         const padding = new RegExp(elem.text().match(/\n[ \t]+/), 'g');
         elem.text(elem.text().replace(padding, '\n').replace(/\t/g, indent).trim());
         elem.parent().addClass('hljs-enhance').closest('figure').addClass('hljs-enhance');
         window.hljs.highlightBlock(elem[0]);
         };
      const onDocumentReady = () => {
         $('pre code:not(.hljs-done)').each(init).addClass('hljs-done');
         $('figure.hljs-enhance >div').addClass('hljs');  //trim boxes without code
         };
      $(onDocumentReady);
      },
   };

if (typeof module === 'object')
   module.exports = hljsEnhance;  //node module loading system (CommonJS)
if (typeof window === 'object')
   window.hljsEnhance = hljsEnhance;  //support both global and window property

hljsEnhance.setup();
