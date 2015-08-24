//- 提交
siteApp.controller('RepoResouceCtrl',['$scope','$http',function($scope,$http){
	$scope.edit_item = {}
	$scope.init = function(repo_id,owner,alia){
		$scope.list = list_data($scope,$http,'/repo/'+owner+'/'+alia+'/resources','resources',null,function(data){ 
			_.each(data.items,function(item){
				item.can_edit =  item.mem_id == Rails.mem_id && item.recsts == '1';
			}) 
			return data;
		});
		$scope.list(0,100);
		$scope.edit_item.repo_id = repo_id;

		$scope.sub = function(){
			if(!$scope.edit_item.title || !$scope.edit_item.url){
				return false;
			}
			$http.post('/resource/save',$scope.edit_item).success(function(data){ 
	      $scope.list(0,100);
	      $scope.edit_item = {}
	      $scope.edit_item.repo_id = repo_id;
	      reset_from();
	    })
		}

		$scope.edit = function(item){
			$scope.edit_item = item;
		}

		$scope.destroy = function(item){
			if(!confirm("确定删除该资源？")){return false}
			$http.post('/resource/'+item.id+'/destroy',{}).success(function(data){ 
	      $scope.list(0,100);
	      $scope.edit_item = {}
	      $scope.edit_item.repo_id = repo_id;
	      reset_from();
	    })
		}
	}

	
  
}])
