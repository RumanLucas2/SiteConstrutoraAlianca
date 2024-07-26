(function() {
	tinymce.create('tinymce.plugins.ThinkButton', {
		init : function(ed, url) {
			ed.addButton('thinkbutton', {
				title : 'Think Button',
				image : url+'/thinkbutton.png',
				onclick : function() {
					//idPattern = /(?:(?:[^v]+)+v.)?([^&=]{11})(?=&|$)/;
					//var vidId = prompt("YouTube Video", "Enter the id or url for your video");
					//var m = idPattern.exec(vidId);
					//if (m != null && m != 'undefined')
					//	ed.execCommand('mceInsertContent', false, '[youtube id="'+m[1]+'"]');
					tb_show("Button Get" ,url+"/think_button_modal.php?");
                    			tinymce.DOM.setStyle(["TB_overlay", "TB_window", "TB_load"], "z-index", "999999")
				}
			});
		},
		createControl : function(n, cm) {
			return null;
		},
		getInfo : function() {
			return {
				longname : "Brett's YouTube Shortcode",
				author : 'Brett Terpstra',
				authorurl : 'http://brettterpstra.com/',
				infourl : 'http://brettterpstra.com/',
				version : "1.0"
			};
		}
	});
	tinymce.PluginManager.add('thinkbutton', tinymce.plugins.ThinkButton);
})();
