/*----------------------------------------
 # jQuery ImageTag 0.1
 # Autor  	Israel De La Hoz
 # Version		1.0.0
 # Date			30/01/2013
 # github: http://github.com/idelahoz
----------------------------------------*/
(function() {
  var $;

  $ = jQuery;

  $.fn.imageTag = function(options) {
    var _add_tags, _attatch_tagform_events, _createWrapper, _disable, _disable_all, _enable, _enable_all, _hide_tag, _hide_tag_all, _hide_tags, _hide_tags_all, _init, _initPlugin, _remove_tag, _remove_tag_all, _remove_unsaved_elements, _set_enable, _show_tag, _show_tag_all, _show_tags, _show_tags_all,
      _this = this;
    this.options = $.extend({
      enableTag: true,
      tagForm: "<form><input type='text' name='name'></input> <input type='hidden' name ='x'/><input type='hidden' name ='y'/></form>",
      onTag: function(form) {},
      labelProperty: 'name',
      idProperty: 'id',
      propertyX: 'x',
      propertyY: 'y',
      tags: [],
      showTagsWhenDisabled: true
    }, options);
    _initPlugin = function(el) {
      var wrap;
      wrap = _createWrapper(el);
      if (wrap.data('image-tag-enabled')) {
        wrap.addClass("enabled");
      }
      _add_tags(wrap, _this.options.tags);
      if (!_this.options.showTagsWhenDisabled && !wrap.data('image-tag-enabled')) {
        _hide_tags(wrap);
      }
      return $(wrap).click(function(e) {
        var stopPropagation, tag, tagform;
        e.preventDefault();
        e.stopPropagation();
        if (wrap.data('image-tag-enabled')) {
          tag = $("<div class = 'tagdiv unsaved'>Tag Here</div>");
          tag.css({
            top: e.offsetY,
            left: e.offsetX
          });
          _remove_unsaved_elements(wrap);
          tagform = $('<div class="tagform-wrapper">').append($(_this.options.tagForm).clone());
          tagform.append('<a class="cancel-tag" href="#">Cancel</a>');
          _attatch_tagform_events(tagform);
          tagform.css({
            top: e.offsetY + 20,
            left: e.offsetX
          });
          stopPropagation = function(e) {
            return e.stopPropagation();
          };
          tag.click(stopPropagation);
          tagform.click(stopPropagation);
          $(wrap).append(tag);
          $(wrap).append(tagform);
          tagform.find("input[name=" + _this.options.labelProperty + "]").focus();
          tagform.find("input[name=" + _this.options.propertyX + "]").val(e.offsetX);
          return tagform.find("input[name=" + _this.options.propertyY + "]").val(e.offsetY);
        }
      });
    };
    _attatch_tagform_events = function(formWrap) {
      var imageTag;
      imageTag = _this;
      formWrap.find('form').submit(function(e) {
        var form, label;
        e.preventDefault();
        form = $(this);
        label = form.find("input[name=" + imageTag.options.labelProperty + "]").val();
        if (label.trim() !== "") {
          imageTag.options.onTag(form);
          formWrap.parent().find(".tagdiv.unsaved").text(label);
          formWrap.parent().find(".tagdiv.unsaved").removeClass("unsaved");
          return formWrap.remove();
        }
      });
      return formWrap.find('a.cancel-tag').click(function(e) {
        e.stopPropagation();
        e.preventDefault();
        return _remove_unsaved_elements(formWrap.parent());
      });
    };
    _createWrapper = function(el) {
      var wrap;
      wrap = $(el).wrap('<div class="image-tag-wrapper"/>').parent();
      wrap.data('image-tag-enabled', _this.options.enableTag);
      return wrap;
    };
    _remove_unsaved_elements = function(wrap) {
      $(wrap).find('.tagform-wrapper').remove();
      return $(wrap).find('.tagdiv.unsaved').remove();
    };
    _set_enable = function(el, enabled) {
      $(el).parent().data('image-tag-enabled', enabled);
      if (enabled) {
        return $(el).parent().addClass('enabled');
      } else {
        return $(el).parent().removeClass('enabled');
      }
    };
    _enable = function(el) {
      _set_enable(el, true);
      return _show_tags($(el).parent());
    };
    _disable = function(el) {
      _set_enable(el, false);
      if (!_this.options.showTagsWhenDisabled) {
        return _hide_tags(wrap);
      }
    };
    _init = function() {
      return _this.each(function(index, el) {
        return _initPlugin(el);
      });
    };
    _disable_all = function() {
      return _this.each(function(index, el) {
        return _disable(el);
      });
    };
    _enable_all = function() {
      return _this.each(function(index, el) {
        return _enable(el);
      });
    };
    _show_tags_all = function() {
      return _this.each(function(index, el) {
        return _show_tags($(el).parent());
      });
    };
    _hide_tags_all = function() {
      return _this.each(function(index, el) {
        return _hide_tags($(el).parent());
      });
    };
    _hide_tag_all = function(id) {
      return _this.each(function(index, el) {
        return _hide_tag($(el).parent(), id);
      });
    };
    _show_tag_all = function(id) {
      return _this.each(function(index, el) {
        return _show_tag($(el).parent(), id);
      });
    };
    _remove_tag_all = function(id) {
      return _this.each(function(index, el) {
        return _remove_tag($(el).parent(), id);
      });
    };
    _hide_tags = function(wrapper) {
      return wrapper.find(".tagdiv").hide();
    };
    _show_tags = function(wrapper) {
      return wrapper.find(".tagdiv").show();
    };
    _show_tag = function(wrapper, id) {
      return wrapper.find(".tagdiv[data-tag_id=" + id + "]").show();
    };
    _hide_tag = function(wrapper, id) {
      return wrapper.find(".tagdiv[data-tag_id=" + id + "]").hide();
    };
    _remove_tag = function(wrapper, id) {
      return wrapper.find(".tagdiv[data-tag_id=" + id + "]").remove();
    };
    _add_tags = function(wrapper, tags) {
      return $.each(tags, function(index, tagInfo) {
        var tag;
        tag = $("<div class = 'tagdiv' data-tag_id='" + tagInfo[_this.options.idProperty] + "'>" + (tagInfo[_this.options.labelProperty] || 'unnamed') + "</div>");
        tag.css({
          top: tagInfo[_this.options.propertyY],
          left: tagInfo[_this.options.propertyX]
        });
        return wrapper.append(tag);
      });
    };
    switch (options) {
      case "disable":
        return _disable_all();
      case "enable":
        return _enable_all();
      case "show_tags":
        return _show_tags_all();
      case "hide_tags":
        return _hide_tags_all();
      case "show_tag":
        return _show_tag_all.apply(this, Array.prototype.slice.call(arguments, 1));
      case "hide_tag":
        return _hide_tag_all.apply(this, Array.prototype.slice.call(arguments, 1));
      case "remove_tag":
        return _remove_tag_all.apply(this, Array.prototype.slice.call(arguments, 1));
      default:
        return _init();
    }
  };

}).call(this);