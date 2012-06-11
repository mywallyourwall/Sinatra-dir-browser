$ ->
 $('#directory li').on 'mouseover', () ->
  $this = $ this
  _href = $this.find('a').attr 'data-preview'
  if _href and $this.data('loaded') != true
   $.ajax 
    type : 'GET'
    url : _href
    success : (response) ->
     $this.append(response).data 'loaded', true