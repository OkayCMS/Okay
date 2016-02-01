/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
    config.language = 'ru';
    config.uiColor = '#56b9ff';
    config.toolbar_Full =
        [

            { name: 'document',    items : [ 'Source','-','Save']},
            { name: 'styles',      items : [ 'Format','FontSize' ] },
            { name: 'colors',      items : [ 'TextColor','BGColor' ] },
            { name: 'clipboard',   items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
            { name: 'tools',       items : [ 'Maximize'] },
            '/',
            { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
            { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-' ] },
            { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
            { name: 'insert',      items : [ 'Image','Table'] },
            '/',

        ];
    config.toolbar = 'Full';

    config.filebrowserBrowseUrl = 'design/js/ckeditor/kcfinder/kcfinder/browse.php?opener=ckeditor&type=files';
    config.filebrowserImageBrowseUrl = 'design/js/ckeditor/kcfinder/kcfinder/browse.php?opener=ckeditor&type=images';
    config.filebrowserFlashBrowseUrl = 'design/js/ckeditor/kcfinder/kcfinder/browse.php?opener=ckeditor&type=flash';
    config.filebrowserUploadUrl = 'design/js/ckeditor/kcfinder/kcfinder/upload.php?opener=ckeditor&type=files';
    config.filebrowserImageUploadUrl = 'design/js/ckeditor/kcfinder/kcfinder/upload.php?opener=ckeditor&type=images';
    config.filebrowserFlashUploadUrl = 'design/js/ckeditor/kcfinder/kcfinder/upload.php?opener=ckeditor&type=flash';
};