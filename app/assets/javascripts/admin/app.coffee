window.admin =
  list_data: (opt)->
    defaults =
      $el: '#admin-app'
      model: ''
      item_propers: null
      data_callback: null
      pagesize: 15



    options = $.extend({}, defaults, opt || {})


    list_url = '/admin/' + options.model + 's.json'
    destory_url = '/admin/'+ options.model + '/destroy'
    fetch_url = '/admin/'+ options.model + '/fetch'
    empty_url = '/admin/'+ options.model + '/empty'
    
    Vue.filter 'show', (items,field,val)->
      _.filter items, (item)->
        item[field] == val


    app = new Vue
      el: options.$el
      data:
        items: []
        count: '加载中..'
        search: {}
        edit_item: {}
      
      methods:
        list: (page,$pagnation)->
          page |= 1
          pagesize = options.pagesize
          $pagnation  = $pagnation || $("#pagenation")
          $.get list_url, {page : page,pagesize: pagesize,filter: app.search}, (data)->
            if options.item_propers
              _.each data.items, (item)->
                _.each options.item_propers, (value, key)->
                  item[key] = value

            if options.data_callback
              data = options.data_callback(data)
            app.items = data.items
            app.count = data.count
            if $pagnation
              if data.count > 0
                $pagnation.pagination data.count,
                  items_per_page : pagesize
                  current_page : page - 1
                  callback : (page)->
                    now_page = page 
                    app.list page + 1, $pagnation
        
        destroy: (item) ->
          if confirm('确定删除该记录？')
            $.post destory_url, {id : item.id}, (data)->
              if data.status
                app.items = _.without app.items, item
              

        fetch: (item) ->
          item.fetching = true
          $.post fetch_url,{id : item.id}, (data)-> 
            item.status = "READED"
            item.fetching = false 

        emptylist: () ->
          if confirm('确定删除列表？谨慎操作')
            $.post empty_url,{}, (data)-> 
              app.items = []
        
      
          
        
      watch:
        "search":
          handler: (Val, oldVal)->
            app.list()
          deep: true  
 
                      
    app.list()

    app
                  
