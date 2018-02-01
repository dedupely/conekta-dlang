module conekta.conekta;

import std.stdio;
import std.json;
import json.common;
import json.from;
import json.to;
import std.net.curl;
import std.conv;
import std.string;
import conekta.domain;

class Conekta {

  private string api_key;
  private string api_version;
  private string locate;

this(string key, string _version, string locate){
  this.api_key = key;
  this.api_version = _version;
  this.locate = locate;
} 

string getVersion(){
return this.api_version;
}

string getLocate(){
return this.locate;
}
string getApi(){
return this.api_key;
}

/* unittest{
  BasicCustomer customer;
  customer.name="Sandra Martin";
  customer.email="usuario@example.com";
  customer.phone="+5215555555555";
  //customer.plan_id="gold-plan";
  customer.corporate= true;
  //customer.id="cus_zzmjKsnM9oacyCwV3";
  ShippingContacts shippings;
  
  ShippingContact contact;
  contact.phone = "+5215555555555";
  contact.receiver = "Marvin Fuller";
  contact.between_streets = "Ackerman Crescent";
  
  Address address;
  address.street1="250 Alexis St";
  address.city="Red Deer";
  address.state="Alberta";
  address.country="CA";
  address.postal_code="T4N 0B8";
  address.residential=true;
  
  contact.address=address;
  shippings.data=[contact];
  customer.shipping_contacts=[contact];
  
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  string result = "";
  result = conekta.createCustomer(customer);
  assert(result != ""); 
} */
 
string createCustomer(BasicCustomer c){
  JSONValue json = structureToJSON!BasicCustomer(c);

  string response = "";
  auto http = HTTP("https://api.conekta.io/customers");
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key,"", "");
  http.method = HTTP.Method.post;
  http.postData = json.toString;
  http.onReceive = (ubyte[] data) { 
    response ~= cast(string)data;
    return data.length; 
  };
  http.verbose = true;
  http.perform();
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object ~ " " ~ error.type ~ " " ~ 
	  getDebugMessageToString(error.details));
  }
  JSONValue jsn = parseJSON(response);
return jsn["id"].str;
}

unittest{
  Customer customer;
  Customer customer2;
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  string result="";
  customer = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer
  
  customer.name="Sandra Martinez";
  customer.email="sandra134@example.com";
  customer.phone="+5215555555666";
  conekta.updateCustomer(customer);
  customer2 = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer
 
assert(customer2.email == customer.email);
}

void updateCustomer(Customer c){
  JSONValue json = structureToJSON!Customer(c);
  string customer_string = json.toString;
  string response = "";
  
  if(c.default_payment_source_id == "" || c.default_payment_source_id == null){
	customer_string = customer_string.replace(`"default_payment_source_id":"",`
	,"");
  }
  auto http = HTTP("https://api.conekta.io/customers/" ~ c.id);
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.put;
  http.onSend = (void[] data) {
		auto m = cast(void[])customer_string;
		size_t len = m.length > data.length ? data.length : m.length;
		if (len == 0) return len;
		data[0..len] = m[0..len];
		customer_string = customer_string[len..$];
		return len;
  };
  //http.verbose(true);
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
    return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	  getDebugMessageToString(error.details));
  }
}

unittest{
  Customer customer;
  
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  string result="";
  customer = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer
  
  customer.name="Mario Pérez Sosa";
  customer.email="usuario134@example.com";
  customer.phone="+5215555555666";
  conekta.updateCustomer(customer);
  
 
assert("cus_2gFNZr9DoFve6WJap" == customer.id);
}

Customer getCustomer(string id){
  string response="";
  auto http = HTTP("https://api.conekta.io/customers" ~ "/" ~ id);
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.get;

  http.onReceive = (ubyte[] data) {
     response ~= cast(string)data;
  return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	  getDebugMessageToString(error.details));
  }
  JSONValue jsn = parseJSON(response);
  Customer customer = jsonToStructure!Customer(jsn);

return customer;
}

/* unittest{
  Customer customer;
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  string result="";
  conekta.addSubscription("cus_2gFNZr9DoFve6WJap","gold-plan");//plan name reference
  customer = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer
  
  assert("gold-plan" == customer.subscription.plan_id);
} */

void addSubscription(string customer_id, string plan) {
  string data = ` { "plan":"` ~ plan ~ `" } `;
  string response = "";
  auto http = HTTP("https://api.conekta.io/customers/" ~ 
    customer_id ~ "/subscription");
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.post;
  http.postData = data;
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
  return data.length; 
  };
  http.verbose=true;
  http.perform();
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " 
	  ~ getDebugMessageToString(error.details));
  }
  //JSONValue jsn = parseJSON(response);
}

unittest{
  Customer customer;
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  string result="";
  conekta.updateSubscription("cus_2gFNZr9DoFve6WJap","silver-plan");//plan name reference
  customer = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer

  assert("silver-plan" == customer.subscription.plan_id);
}

void updateSubscription(string customer_id, string plan){
  string newplan = ` { "plan":"` ~ plan ~ `" } `;
  string response = "";
  auto http = HTTP("https://api.conekta.io/customers/" ~ 
    customer_id ~ "/subscription");
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.put;
  http.onSend = (void[] data) {
		auto m = cast(void[])newplan;
		size_t len = m.length > data.length ? data.length : m.length;
		if (len == 0) return len;
		data[0..len] = m[0..len];
		newplan = newplan[len..$];
		return len;
  };
  //http.verbose(true);
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
    return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	  getDebugMessageToString(error.details));
  }
}

/* unittest{
  Customer customer;
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  conekta.cancelSubscription("cus_2gE4s9iTK9ajR71fs","gold-plan");//plan name reference
  customer = conekta.getCustomer("cus_2gE4s9iTK9ajR71fs");//id customer
  
  assert("canceled" == customer.subscription.status);
} */

void cancelSubscription(string customer_id, string plan){
  Customer cu = getCustomer(customer_id);

  Subscription source= cu.subscription;
  source.status="canceled";
  JSONValue json = structureToJSON!Subscription(source);
  string suscription_string = json.toString;
  string response = "";
  
  auto http = HTTP("https://api.conekta.io/customers/" ~ 
    customer_id ~ "/subscription/cancel");
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.post;
  http.postData=suscription_string;
  //http.verbose(true);
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
    return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	 getDebugMessageToString(error.details));
  }

}

/* unittest{
  Customer customer;
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  string result="";
  conekta.pauseSubscription("cus_2gFNZr9DoFve6WJap","gold-plan");//plan name reference
  customer = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer
  
  assert("paused" == customer.subscription.status);
} */

void pauseSubscription(string customer_id, string plan){
  Customer cu = getCustomer(customer_id);

  Subscription source= cu.subscription;
  source.status="paused";
  JSONValue json = structureToJSON!Subscription(source);
  string suscription_string = json.toString;
  string response = "";
  
  auto http = HTTP("https://api.conekta.io/customers/" ~ 
    customer_id ~ "/subscription/pause");
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.post;
  http.postData=suscription_string;
  //http.verbose(true);
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
    return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	  getDebugMessageToString(error.details));
  }
}

/* unittest{
  Customer customer;
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  string result="";
  conekta.resumeSubscription("cus_2gFNZr9DoFve6WJap","gold-plan");//plan name reference
  customer = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer
  
  assert("active" == customer.subscription.status);
} */

void resumeSubscription(string customer_id, string plan){
  Customer cu = getCustomer(customer_id);

  Subscription source= cu.subscription;
  source.status="active";
  JSONValue json = structureToJSON!Subscription(source);
  string suscription_string = json.toString;
  string response = "";
  
  auto http = HTTP("https://api.conekta.io/customers/" ~ 
    customer_id ~ "/subscription/resume");
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.post;
  http.postData=suscription_string;
  //http.verbose(true);
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
    return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	  getDebugMessageToString(error.details));
  }
}

/* unittest{

  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  PaymentSource payment;
  Customer customer;
  payment = conekta.createPaymentSource("cus_2gFNZr9DoFve6WJap",
    "tok_test_visa_1881");//plan name reference
  customer = conekta.getCustomer("cus_2gFNZr9DoFve6WJap");//id customer
  
  
  assert("VISA" == customer.payment_sources.data[0].brand);
  assert(payment.brand == customer.payment_sources.data[0].brand);
} */

PaymentSource createPaymentSource(string customer_id, string token, 
    string type="card") {
	
  string source=`{"token_id": "` ~ token ~ `", "type": "` ~ type ~ `" }`;
  string response = "";
  auto http = HTTP("https://api.conekta.io/customers/" ~ 
    customer_id ~ "/payment_sources");
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.post;
  http.postData=source;
  http.verbose(true);
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
    return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	 getDebugMessageToString(error.details));
  }
  JSONValue jsn = parseJSON(response);
  PaymentSource payment_source = jsonToStructure!PaymentSource(jsn);
  
return payment_source;
}

unittest{
  
  Conekta conekta= new Conekta("key_4TyLz7WnCgmmyGhyB5woDw","2.0.0","es");
  PaymentSource payment;
  Customer customer;
  customer = conekta.getCustomer("cus_2gE4s9iTK9ajR71fs");//id customer
  payment = customer.payment_sources.data[0];
  payment.exp_month = "10";
  payment.exp_year = "20";
  Address address; //address is not nullable
  address.street1 = "Tamesis";
    
  address.city = "Monterrey";
  address.state = "Nuevo Leon";
  address.country = "mx";
  //  "object": "address",
  address.postal_code = "64700";
  payment.address = address;
  conekta.updatePaymentSource("cus_2gE4s9iTK9ajR71fs",payment);//plan name reference
  
  
  assert("VISA" == customer.payment_sources.data[0].brand);
  assert(payment.brand == customer.payment_sources.data[0].brand);
}

void updatePaymentSource(string customer_id, PaymentSource payment_source){
  JSONValue json = structureToJSON!PaymentSource(payment_source);
  string payment = json.toString;
  payment = payment.replace(`"type":"card,"`,"");
  payment = payment.replace(`,"type":"card"`,"");
  
  string response = "";
  auto http = HTTP("https://api.conekta.io/customers/" ~ customer_id ~ 
    "/payment_sources/" ~ payment_source.id);
  http.addRequestHeader("Accept", "application/vnd.conekta-v" ~ 
    this.api_version ~ "+json");
  http.addRequestHeader("Content-Type", "application/json");
  http.setAuthentication(this.api_key, "", "");
  http.method = HTTP.Method.put;
  http.onSend = (void[] data) {
		auto m = cast(void[])payment;
		size_t len = m.length > data.length ? data.length : m.length;
		if (len == 0) return len;
		data[0..len] = m[0..len];
		payment = payment[len..$];
		return len;
  };
  //http.verbose(true);
  http.onReceive = (ubyte[] data) {
    response ~= cast(string)data;
    return data.length; 
  };

  http.perform(); 
  auto s = http.statusLine();
  if(s.code != 200){
    JSONValue jj = parseJSON(response);
    MessageError error = jsonToStructure!MessageError(jj);
	throw new Exception(error.object~" " ~ error.type ~ " " ~ 
	  getDebugMessageToString(error.details));
  }
}

void setKey(string key){
  this.api_key = key;
}

void setVersion(string _version){
  this.api_version = _version;
}

void setLocate(string locate){
  this.locate = locate;
}

private string getDebugMessageToString(ConektaException[] details) {
  string message="";
  for(int i=0;i<details.length;i++){
    message~=details[i].debug_message ~ "\n";
  }
  return message;
}

}