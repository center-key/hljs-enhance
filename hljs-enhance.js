// hljs-enhance - https://github.com/center-key/hljs-enhance - MIT License
var hljsEnhance = {
   setup: function() {
      function init(i, elem) {
         elem = $(elem);
         var indent = '   ';
         var padding = new RegExp(elem.text().match(/\n[ \t]+/), 'g');
         elem.text($.trim(elem.text().replace(padding, '\n').replace(/\t/g, indent)));
         elem.parent().addClass('hljs-enhance').closest('figure').addClass('hljs-enhance');
         window.hljs.highlightBlock(elem[0]);
         }
      function onDocumentReady() {
         $('pre code:not(.hljs-done)').each(init).addClass('hljs-done');
         $('figure.hljs-enhance >div').addClass('hljs');  //trim boxes without code
         }
      $(onDocumentReady);
      }
   };
hljsEnhance.setup();

// Blogger hack
if ($('meta[content=blogger]').length)
   window.setInterval(hljsEnhance.setup, 2000);
