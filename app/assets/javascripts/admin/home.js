//- 提交
adminApp.controller('SubmitCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'submit') 
}])


//- 中文说明
adminApp.controller('ReadmeCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'readme') 
}])

//- 所有库
adminApp.controller('RepoCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'repo') 
}])

//- 文档提交
adminApp.controller('DocsubCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'docsub') 
}])

//- 中文文档
adminApp.controller('DocCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'doc') 
}])

//- 资源
adminApp.controller('ResourceCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'resource') 
  $scope.edit = function(item){
    
  }
}])

//- 会员
adminApp.controller('MemCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'mem') 
}])

//- 评论
adminApp.controller('CommentCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'comment') 
}])






function get_data($scope,$http,collection,data_callback){
  var list_url = '/admin/'+collection+'s.json';
  var remove_url = '/admin/'+collection+'/destroy';
  var reset_url = '/admin/'+collection+'/reset';
  var confirm_url = '/admin/'+ collection +'/confirm';
  var fetch_url = '/admin/'+ collection +'/fetch';
  var sync_url = '/admin/'+ collection +'/sync';

  var now_page = 1;

  $scope.where = {};

  $scope.get_list = function(page,para,pagesize){
    if (!para) {para = {}};
    if(!pagesize){pagesize = 15};
    $http.post(list_url,{page : page,pagesize: pagesize, para : para}).success(function(data){
      if(data_callback){
        data = data_callback(data);
      }
      $('#totalc').html(data.count);
      $('#pagenation').pagination(data.count,{
        items_per_page : pagesize,
        current_page : page-1,
        callback : function(page){
          now_page = page; 
          $scope.get_list(page+1,para);
        } 
      });
      $scope.items = data.items; 
    })
  }

  $scope.search = function(field){   
    if ($scope['filter_' + field] == '') {
     $scope.where =  _.omit($scope.where,field);
    }else{ 
      eval("_.extend($scope.where,{'"+field+"': $scope['filter_' + field]}); ")
    }
    $scope.get_list(1,$scope.where); 

  }

  $scope.destroy=function(id){
    if(collection == 'video' || collection == 'plugin' || collection == 'code'){
      var reson = prompt('请输入删除原因？');
      if (reson != null) { 
        $http.post(remove_url,{id : id,reson : reson}).success(function(data){
          angular.element($('#list')).scope().get_list(now_page);
        });
      }
    }else{
      if(confirm('确定删除该记录？')){
        $http.post(remove_url,{id : id,reson : reson}).success(function(data){
          angular.element($('#list')).scope().get_list(now_page);
        });
      }
    } 
    
  }

  $scope.reset = function(id){
    $http.post(reset_url,{id : id}).success(function(data){ 
      angular.element($('#list')).scope().get_list(now_page);
    })
  }

  $scope.fetch = function(item){
    $http.post(fetch_url,{id : item.id}).success(function(data){ 
      //angular.element($('#list')).scope().get_list(now_page);
      item.synced = true;
    })
  }

  $scope.sync = function(item){
    $http.post(sync_url,{id : item.id}).success(function(data){ 
      //angular.element($('#list')).scope().get_list(now_page);
      item.synced = true;
    })
  }


  $scope.confirm = function(id){
    if(confirm('确定此操作？')){
      $http.post(confirm_url,{id : id}).success(function(data){ 
        angular.element($('#list')).scope().get_list(now_page);
      });
    }
    
  }

  $scope.notify = function(mem_id){
    current_mem_id = mem_id;
  }
}
