(function() {
  window.admin = {
    list_data: function(opt) {
      var app, defaults, destory_url, empty_url, fetch_url, list_url, options;
      defaults = {
        $el: 'body',
        model: '',
        item_propers: null,
        data_callback: null,
        pagesize: 15
      };
      options = $.extend({}, defaults, opt || {});
      list_url = '/admin/' + options.model + 's.json';
      destory_url = '/admin/' + options.model + '/destroy';
      fetch_url = '/admin/' + options.model + '/fetch';
      empty_url = '/admin/' + options.model + '/empty';
      Vue.filter('show', function(items, field, val) {
        return _.filter(items, function(item) {
          return item[field] === val;
        });
      });
      app = new Vue({
        el: options.$el,
        data: {
          items: [],
          count: '加载中..',
          search: {},
          edit_item: {},
          wealth: {
            model: '',
            id: '',
            price: 0
          }
        },
        methods: {
          list: function(page, $pagnation) {
            var pagesize;
            page |= 1;
            pagesize = options.pagesize;
            $pagnation = $pagnation || $("#pagenation");
            return $.get(list_url, {
              page: page,
              pagesize: pagesize,
              filter: app.search
            }, function(data) {
              if (options.item_propers) {
                _.each(data.items, function(item) {
                  return _.each(options.item_propers, function(value, key) {
                    return item[key] = value;
                  });
                });
              }
              if (options.data_callback) {
                data = options.data_callback(data);
              }
              app.items = data.items;
              app.count = data.count;
              if ($pagnation) {
                if (data.count > 0) {
                  return $pagnation.pagination(data.count, {
                    items_per_page: pagesize,
                    current_page: page - 1,
                    callback: function(page) {
                      var now_page;
                      now_page = page;
                      return app.list(page + 1, $pagnation);
                    }
                  });
                }
              }
            });
          },
          destroy: function(item) {
            if (confirm('确定删除该记录？')) {
              return $.post(destory_url, {
                id: item.id
              }, function(data) {
                if (data.status) {
                  return app.items = _.without(app.items, item);
                }
              });
            }
          },
          fetch: function(item) {
            item.fetching = true;
            return $.post(fetch_url, {
              id: item.id
            }, function(data) {
              item.status = "READED";
              return item.fetching = false;
            });
          },
          emptylist: function() {
            if (confirm('确定删除列表？谨慎操作')) {
              return $.post(empty_url, {}, function(data) {
                return app.items = [];
              });
            }
          }
        },
        watch: {
          "search": {
            handler: function(Val, oldVal) {
              return app.list();
            },
            deep: true
          }
        }
      });
      app.list();
      return app;
    }
  };

}).call(this);
