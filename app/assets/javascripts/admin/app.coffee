window.admin =
  list_data: ($el,model,item_propers,data_callback)->
    return if !$el
    list_url = '/admin/' + model + 's.json'
    destory_url = '/admin/'+ model + '/destroy'
    fetch_url = '/admin/'+ model + '/fetch'


    app = new Vue
      el: $el
      data:
        items: []
        count: '加载中..'
        search: {}
      
      methods:
        list: (page,pagesize,$pagnation)->
          page |= 1
          pagesize  |=  15
          $pagnation  = $pagnation || $("#pagenation")
          $.get list_url, {page : page,pagesize: pagesize,filter: app.search}, (data)->
            if item_propers
              _.each data.items, (item)->
                _.each item_propers, (value, key)->
                  item[key] = value

            if data_callback
              data = data_callback(data)
            app.items = data.items
            app.count = data.count
            if $pagnation
              if data.count > 0
                $pagnation.pagination data.count,
                  items_per_page : pagesize
                  current_page : page - 1
                  callback : (page)->
                    now_page = page 
                    app.list page + 1, pagesize, $pagnation
        
        destroy: (item) ->
          if confirm('确定删除该记录？')
            $.post destory_url, {id : item.id}, (data)->
              app.items = _.without app.items, item

        fetch: (item) ->
          item.fetching = true
          $.post fetch_url,{id : item.id}, (data)-> 
            item.status = "READED"
            item.fetching = false 

      watch:
        "search":
          handler: (Val, oldVal)->
            app.list()
          deep: true  
 
                      
    app.list()
                  