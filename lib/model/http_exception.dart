




class HttpException implements Exception{ //implement = our class is forced to implement all function the implemented (our case Exceptions) has; Exceptions is an abstract class = can't be instantiated

final String message; //exception tipically store a message

HttpException(this.message);

@override 
String toString() { //all classes have this method, but because we implemented Exception, we need to overwrite it; toString returns "instance of 'name of the class'"
  return message;
//return super.toString(); //instead of returning this, which would return "instannce of HttpException", we return the message

}


}