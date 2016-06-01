# EnginePHP5
Engine API is on the move. The API primarily developed for WVU libraries provides great options for making applications. This repository hosts a simple application running on PHP 5.6 and CentOS7.2.

Running the tests:
1. `cd folder\location\EnginePHP5`
2. `vagrant up`
3. `vagrant ssh`
4. `cd /vagrant/`
5. Run the respective test; to run validateTest use:
```php
phpunit --bootstrap EngineTests/bootstrap.php EngineTests/engineAPI/Modules/Validate/validateTest.php
```
