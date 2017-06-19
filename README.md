### Awesomes

> this code will not be maintained any more. Please check out the new version https://github.com/awesomes-cn/new-awesomes


Source code  [awesomes.cn](http://www.awesomes.cn)

why **awesomes** you can get best framwork, library tools.

### How to run in local 

1: requirement lib

	* Ruby 2.2.0 +
	* Rails 4.2.2+
	* Mysql 5.0+
	* ImageMagick 6.5+
	* elasticsearch 2.3.+

2: clone project

```
$ git clone git@github.com:awesomes-cn/awesomes.git

```

3: bundle install & create db

```
$ cd project_path && bundle install 
$ rake db:create && rake db:migrate

```
4: init some test data

```
$ rake db:repos:init

```

5: start the server

```
$ cd project_path && rails s

```

6: visit the url [awesome.cn](http://localhost:3000)


## Contributors

* [Contributors](https://github.com/awesomes-cn/awesomes/graphs/contributors)

## Thanks

* [Twitter Bootstrap](https://twitter.github.com/bootstrap)
* [Font Awesome](http://fortawesome.github.io/Font-Awesome/icons/)
* [codemirror](https://github.com/codemirror/CodeMirror)
* [prism](https://github.com/PrismJS/prism)

## License

 Awesomes.cn Released under the [MIT license](http://www.opensource.org/licenses/MIT)
