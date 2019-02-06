# WishList

WishList application allows you to create, delete and modify products on your iOS devices, and then send the corresponding changes to the server.

[![swift 4.2.1](https://img.shields.io/badge/swift-4.2.1-blue.svg)](https://swift.org/download/#releases)
[![python 3.7.2](https://img.shields.io/badge/python-3.7.2-blue.svg)](https://www.python.org/downloads/release/python-372/)
[![flask 1.0.2](https://img.shields.io/badge/flask-1.0.2-blue.svg)](http://flask.pocoo.org)
[![MIT](https://img.shields.io/github/license/sergeyshalnov/wishlist.svg?style=flat)](https://github.com/sergeyshalnov/WishList/blob/master/LICENSE)
![](https://img.shields.io/badge/Updated-February%20%206,%202019-lightgrey.svg)

Install
----
Clone the repository to your computer and install all dependencies.
```
$ git clone git@github.com:sergeyshalnov/WishList.git
$ cd BackendAPI
$ pip install -r requirements.txt
```

Preparing
----
Next you need to configure the MySQL database. 
```
mysql > CREATE USER 'sergeyshalnov'@'localhost' IDENTIFIED BY 'sergeyshalnov'; 
mysql > GRANT ALL PRIVILEGES ON * . * TO 'sergeyshalnov'@'localhost';
mysql > CREATE DATABASE WISHLIST
mysql > USE WISHLIST
```

Running
----
Now you can start the server and launch the iOS application in XCode iPhone Simulator.
```
$ python run.py

* Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
* Restarting with stat
* Debugger is active!
* Debugger PIN: 186-789-811
```

License
----

[The MIT License (MIT)](https://github.com/dustLane/Swift/blob/master/LICENSE)
