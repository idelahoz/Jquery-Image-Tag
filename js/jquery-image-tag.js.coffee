#----------------------------------------
 # jQuery ImageTag 0.1
 # Autor		Israel De La Hoz
 # Version		1.0.0
 # Date			30/01/2013
 # github: http://github.com/idelahoz
#----------------------------------------
$ = jQuery

$.fn.imageTag = (options) ->
  
  @options = $.extend({
    enableTag: true
    tagForm: "<form><input type='text' name='name'></input> <input type='hidden' name ='x'/><input type='hidden' name ='y'/></form>"
    onTag: (form) ->
    labelProperty: 'name'
    idProperty: 'id'
    propertyX: 'x'
    propertyY: 'y'
    distanceUnity: 'pixels' #posible values : pixel, percentage
    requiredFields: ['name']
    tags: []
    showTagsWhenDisabled: true
    }
    , options)
  
  _initPlugin = (el) =>
    wrap = _createWrapper(el)
    wrap.addClass("enabled") if wrap.data('image-tag-enabled')
    if $.fn.imagesLoaded
      wrap.imagesLoaded( () =>  _add_tags wrap, @options.tags)
    else
      _add_tags wrap, @options.tags
      
    _hide_tags(wrap) if !@options.showTagsWhenDisabled && !wrap.data('image-tag-enabled')
    $(wrap).click(
      (e) =>
        e.preventDefault()
        e.stopPropagation()
        unless e.offsetX or e.offsetY
          offX = e.pageX - $(e.target).offset().left
          offY = e.pageY - $(e.target).offset().top
        else
          offX = e.offsetX
          offY = e.offsetY
          
        if wrap.data('image-tag-enabled')
          tag = $("<div class = 'tagdiv unsaved'>Tag here</div>")
          tag.css top:offY, left:offX
          
          _remove_unsaved_elements(wrap)
          
          tagform = $('<div class="tagform-wrapper">').append $(@options.tagForm).clone()
          tagform.append('<a class="cancel-tag" href="#">Cancel</a>')
            
          # attatch submit event to the internal form  
          _attatch_tagform_events tagform
          
          tagform.css top:offY + 20, left:offX
          stopPropagation = (e) -> e.stopPropagation()
          
          #prevent from execute this event on the tag and the form
          tag.click stopPropagation
          tagform.click stopPropagation
          
          #append the elements to the div
          $(wrap).append tag
          $(wrap).append tagform
          
          #set the focus on the field for the label
          tagform.find("input[name=#{@options.labelProperty}]").focus()
          tagform.find("input[name=#{@options.propertyX}]").val(eval("_pixels_to_#{@options.distanceUnity}")(wrap, 'x', offX))
          tagform.find("input[name=#{@options.propertyY}]").val(eval("_pixels_to_#{@options.distanceUnity}")(wrap, 'y', offY))
    )
    
  _attatch_tagform_events = (formWrap) =>
    imageTag = @;
    formWrap.find('form').submit (e) ->
      e.preventDefault();
      form = $(@)
      label = form.find("input[name=#{imageTag.options.labelProperty}]").val()
      if _check_required_fields(formWrap)
        imageTag.options.onTag(form)
        
        formWrap.parent().find(".tagdiv.unsaved").text(label)
        formWrap.parent().find(".tagdiv.unsaved").removeClass("unsaved")
        formWrap.remove()
        
    formWrap.find('a.cancel-tag').click (e) ->
      e.stopPropagation()
      e.preventDefault()
      _remove_unsaved_elements(formWrap.parent())
      
  _check_required_fields = (formWrap) =>
    filled = true;
    selector = $.map(@options.requiredFields, (field) -> "input[name=#{field}]" ).join(",")
    $(selector).each(
      (index, el ) ->
        filled = false if $(el).val().trim() == ""
        true
    )
    filled
    
  #create the div to contain the image to hold the tags  
  _createWrapper = (el) =>
    wrap = $(el).wrap('<div class="image-tag-wrapper"/>').parent()
    wrap.data('image-tag-enabled', @options.enableTag)
    wrap
  
  #removes unsaved tags and pending forms
  _remove_unsaved_elements = (wrap) =>
    $(wrap).find('.tagform-wrapper').remove()
    $(wrap).find('.tagdiv.unsaved').remove()
  
  _set_enable = (el, enabled) =>
     $(el).parent().data('image-tag-enabled', enabled)
     if enabled
       $(el).parent().addClass('enabled')
     else
       $(el).parent().removeClass('enabled')
     
  _enable = (el) =>
     _set_enable el, true
     _show_tags($(el).parent())
     
  _disable = (el) =>
     _set_enable el, false
     _hide_tags(wrap) if !@options.showTagsWhenDisabled
     
  _init = () =>
    this.each (index, el) ->
      _initPlugin(el)
      
  _disable_all = () =>
    this.each (index, el) ->
      _disable(el)
      
  _enable_all = () =>
    this.each (index, el) ->
      _enable(el)
      
  _show_tags_all = () =>
    this.each (index, el) ->
      _show_tags($(el).parent())
      
  _hide_tags_all = () =>
    this.each (index, el) ->
      _hide_tags($(el).parent())
      
  _hide_tag_all = (id) =>
    this.each (index, el) ->
      _hide_tag($(el).parent(), id)
  
  _show_tag_all = (id) =>
    this.each (index, el) ->
      _show_tag($(el).parent(), id)
      
  _remove_tag_all = (id) =>
    this.each (index, el) ->
      _remove_tag($(el).parent(), id)
  
  _hide_tags = (wrapper) =>
    wrapper.find(".tagdiv").hide()
    
  _show_tags = (wrapper) =>
    wrapper.find(".tagdiv").show()
    
  _show_tag = (wrapper, id) =>
    wrapper.find(".tagdiv[data-tag_id=#{id}]").show()
  
  _hide_tag = (wrapper, id) =>
    wrapper.find(".tagdiv[data-tag_id=#{id}]").hide()
    
  _remove_tag = (wrapper, id) =>
    wrapper.find(".tagdiv[data-tag_id=#{id}]").remove()
      
  _add_tags = (wrapper, tags) =>
    $.each tags, (index, tagInfo) =>
      tag = $("<div class = 'tagdiv' data-tag_id='#{tagInfo[@options.idProperty]}'>#{tagInfo[@options.labelProperty] || 'unnamed'}</div>")
      tag.css 
       top: eval("_#{@options.distanceUnity}_to_pixels")(wrapper, 'y', tagInfo[@options.propertyY]),
       left: eval("_#{@options.distanceUnity}_to_pixels")(wrapper, 'x', tagInfo[@options.propertyX])
      wrapper.append tag
      
  _pixels_to_percentage = (wrapper, orientation, pixels) =>
    lenght = if orientation is "x" then wrapper.width() else wrapper.height()
    pixels/lenght
    
  _percentage_to_pixels = (wrapper, orientation, percentage) =>
    lenght = if orientation is "x" then wrapper.width() else wrapper.height()
    lenght * percentage
    
  _pixels_to_pixels = (wrapper, orientation, pixels) =>
    pixels
  
  switch options
    when "disable" then _disable_all()
    when "enable" then _enable_all()
    when "show_tags" then _show_tags_all()
    when "hide_tags" then _hide_tags_all()
    when "show_tag" then _show_tag_all.apply( @, Array.prototype.slice.call( arguments, 1 ))
    when "hide_tag" then _hide_tag_all.apply( @, Array.prototype.slice.call( arguments, 1 ))
    when "remove_tag" then _remove_tag_all.apply( @, Array.prototype.slice.call( arguments, 1 ))
    else _init()