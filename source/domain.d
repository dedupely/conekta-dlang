module conekta.domain;

import std.stdio;
import std.json;
import json.common;
import json.from;
import json.to;


struct Order {

  string id;
  //string object;
  bool livemode;
  int amount;
  int amount_refunded;
  string payment_status;
  string currency;
  CustomerInfo customer_info;
  int created_at;
  int updated_at;
  LineItems line_items;
  Charges charges;
  //metadata
  
}
unittest{

string strin=` {
  "id": "ord_2fw8YeLSqoaGEYTn3", "livemode": false, "amount": 35000,
  "amount_refunded": 0, "payment_status": "paid","currency": "MXN",
  "customer_info":{ "name": "marcos", "email": "marcos@gmail.com", 
  "phone": "1385481591","customer_id": "src_2fw8YeLSqoaGEYTn3" },
  "created_at": 1485842107, "updated_at": 1485842112,
  "line_items": { "data": [ { "id": "ship_cont_2fww6ojquQSVXFKzc", 
  "name": "cola", "description": "refresco", 
  "unit": 97189, "parent_id":"ord_2fw8EWJusiRrxdPzT", "sku": "nnas",
  "brand": "brand", "quantity": 5 } ],
  "has_more": false, "total": 1 }  ,
  "charges":{ "data": [ { "id": "589026bbedbb6e56430016ad", 
  "status": "pending_payment", "amount": 12, 
  "fee": 97189, "order_id":"ord_2fw8EWJusiRrxdPzT", "livemode": true,
  "currency": "MXN", "created_at": 5123, "payment_method":{
  "id": "jkhhkhuayuqo12jda", "type":"oxxo", "created_at":12312433,
  "last4": "8792","name":"cash", "exp_month": "12", "exp_year": "1201",
  "brand": "breand", "parent_id": "haeui26ay74iak",
  "address":{ "street1": "23 green", "city": "Merida", "state": "Califonia",
  "postal_code": "97189", "country":"USA", "residential": false }
  } } ], "has_more": false, "total":1 }
  } `;
JSONValue j = parseJSON(strin);
Order c = jsonToStructure!Order(j); 
assert(c.id=="ord_2fw8YeLSqoaGEYTn3");
assert(c.livemode==false);
assert(c.customer_info.customer_id=="src_2fw8YeLSqoaGEYTn3");
}

struct CustomerInfo {

  string name;
  string email;
  string phone;
  string customer_id;
  //string object;
}
unittest{

string strin=` {
  "name": "marcos", "email": "marcos@gmail.com", "phone": "1385481591",
  "customer_id": "src_2fw8YeLSqoaGEYTn3"
  } `;
JSONValue j = parseJSON(strin);
CustomerInfo c = jsonToStructure!CustomerInfo(j); 
assert(c.name=="marcos");
assert(c.phone=="1385481591");
assert(c.customer_id=="src_2fw8YeLSqoaGEYTn3");
}

struct Customer {

  string id;
  //string object;
  bool livemode;
  int created_at;
  string name;
  string email;
  string phone;
  bool corporate;
  string default_shipping_contact_id;
  string default_payment_source_id;
  PaymentSources payment_sources;
  ShippingContacts shipping_contacts;
  Subscription subscription;
}

unittest{

string strin=` {
  "id": "cus_zzmjKsnM9oacyCwV3", "livemode": true, "created_at":1385481591,
  "name": "sandra", "email": "sandra@mail.com", 
  "phone": "1385696776",
  "corporate": false, 
  "default_shipping_contact_id": "ship_cont_afbur73vpdhdjwgo", 
  "default_payment_source_id": "src_2fw8YeLSqoaGEYTn3",
  "shipping_contacts": { "data": [ { "id": "ship_cont_2fww6ojquQSVXFKzc", 
  "parent_id": "cus_2fd4nHfkDdNx19jWx", "receiver": "Diego", 
  "created_at": 97189, "phone":"+5218181818181", "between_streets": "",
  "address": { "street1": "23 green", "city": "Merida", "state": "Califonia",
  "postal_code": "97189", "country":"USA", "residential": false }  } ],
  "has_more": false, "total": 1 }, 
  "subscription":{
  "id": "sub_EfhFCp5SKvp5XzXQk", "status": "in_trial", "created_at":1385481591,
  "canceled_at": 98245421, "paused_at": 10000, 
  "billing_cycle_start": 1385696776,
  "billing_cycle_end": 1386301576, "plan_id": "gold-plan", 
  "card_id": "src_2fw8YeLSqoaGEYTn3",
  "trial_start": 15, "trial_end": 3
  }
  } `;
JSONValue j = parseJSON(strin);
Customer c = jsonToStructure!Customer(j); 
assert(c.subscription.trial_start==15);
assert(c.subscription.plan_id=="gold-plan");
assert(c.id=="cus_zzmjKsnM9oacyCwV3");
assert(c.name=="sandra");
assert(c.shipping_contacts.data[0].id=="ship_cont_2fww6ojquQSVXFKzc");
}

struct BasicCustomer {

  //string id;
  //string object;
  bool livemode;
  int created_at;
  string name;
  string email;
  string phone;
  bool corporate;
  //string default_shipping_contact_id;
  string default_payment_source_id;
  PaymentSource[] payment_sources;
  ShippingContact[] shipping_contacts;
  Subscription subscription;
}

struct Subscription {
  string id;
  //string object;
  string status;
  int created_at;
  int canceled_at;
  int paused_at;
  int billing_cycle_start;
  int billing_cycle_end;
  string plan_id;
  string card_id;
  int trial_start;
  int trial_end;
}
unittest{

string strin=` {
  "id": "sub_EfhFCp5SKvp5XzXQk", "status": "in_trial", "created_at":1385481591,
  "canceled_at": 98245421, "paused_at": 10000, 
  "billing_cycle_start": 1385696776,
  "billing_cycle_end": 1386301576, "plan_id": "gold-plan", 
  "card_id": "src_2fw8YeLSqoaGEYTn3",
  "trial_start": 15, "trial_end": 3
  } `;
JSONValue j = parseJSON(strin);
Subscription c = jsonToStructure!Subscription(j); 
assert(c.trial_start==15);
assert(c.plan_id=="gold-plan");
assert(c.id=="sub_EfhFCp5SKvp5XzXQk");
}

struct Plan {
  string id;
  //string object;
  bool livemode;
  int created_at;
  string name;
  int amount;
  string currency;
  string interval;
  int frequency;
  int interval_total_count;
  int trial_period_days;
  int expiry_count;

}
unittest{

string strin=` {
  "id": "gold-plan", "livemode": true, "created_at":1385481591,
  "name": "Gold Plan", "amount": 10000, "currency": "MXN",
  "interval": "month", "frequency": 2, "interval_total_count": 12,
  "trial_period_days": 15, "expiry_count": 3
  } `;
JSONValue j = parseJSON(strin);
Plan c = jsonToStructure!Plan(j); 
assert(c.interval_total_count==12);
assert(c.id=="gold-plan");
assert(c.name=="Gold Plan");
}

struct TaxesLine{
  bool has_more;// = Box of Cohiba S1s,
  int total;
  //string object;
  TaxLine[] data;
}
unittest{

string strin=` { "data":[{
  "id": "jkhhkhuayuqo12jda", "description":"oxxo", "amount":12312
  }], "has_more":false, "total": 1 } `;
JSONValue j = parseJSON(strin);
TaxesLine c = jsonToStructure!TaxesLine(j); 
assert(c.has_more==false);
assert(c.total==1);
assert(c.data[0].amount==12312);
assert(c.data[0].id=="jkhhkhuayuqo12jda");
assert(c.data[0].description=="oxxo");
}

struct TaxLine{
  string id;
  int amount;
  //string object;
  string description;
  //metadata
}
unittest{

string strin=` {
  "id": "jkhhkhuayuqo12jda", "description":"oxxo", "amount":12312
  } `;
JSONValue j = parseJSON(strin);
TaxLine c = jsonToStructure!TaxLine(j); 
assert(c.amount==12312);
assert(c.id=="jkhhkhuayuqo12jda");
assert(c.description=="oxxo");
}

struct PaymentSources{
  bool has_more;// = Box of Cohiba S1s,
  int total;
  //string object;
  PaymentSource[] data;
 
}
unittest{

string strin=` { "data":[{
  "id": "jkhhkhuayuqo12jda", "type":"oxxo", "created_at":12312,
  "last4": "8792","name":"cash", "exp_month": "12", "exp_year": "1201",
  "brand": "breand", "parent_id": "haeui26ay74iak",
  "address":{ "street1": "23 green", "city": "Merida", "state": "Califonia",
  "postal_code": "97189", "country":"USA", "residential": false }
  }], "has_more":false, "total": 1 } `;
JSONValue j = parseJSON(strin);
PaymentSources c = jsonToStructure!PaymentSources(j); 
assert(c.has_more==false);
assert(c.total==1);
assert(c.data[0].parent_id=="haeui26ay74iak");
assert(c.data[0].address.postal_code=="97189");
}

struct PaymentSource{
 string id;
 string type;
 int created_at;
 string last4;
 string name;
 string exp_month;
 string exp_year;
 string brand;
 string parent_id;
 Address address;
 //string object;
 
}

unittest{

string strin=`{
  "id": "jkhhkhuayuqo12jda", "type":"oxxo", "created_at":12312,
  "last4": "8792","name":"cash", "exp_month": "12", "exp_year": "1201",
  "brand": "breand", "parent_id": "haeui26ay74iak",
  "address":{ "street1": "23 green", "city": "Merida", "state": "Califonia",
  "postal_code": "97189", "country":"USA", "residential": false }
  } `;
JSONValue j = parseJSON(strin);
PaymentSource c = jsonToStructure!PaymentSource(j); 
assert(c.id=="jkhhkhuayuqo12jda");
assert(c.type=="oxxo");
assert(c.parent_id=="haeui26ay74iak");
assert(c.address.postal_code=="97189");
}

struct Charge{
  string id;
  //string object;
  string status;
  int amount;
  int fee;
  string order_id;
  bool livemode;
  int created_at;
  string currency;
  PaymentSource payment_method;
}

unittest{

string strin=`{ "id": "589026bbedbb6e56430016ad", 
  "status": "pending_payment", "amount": 12, 
  "fee": 97189, "order_id":"ord_2fw8EWJusiRrxdPzT", "livemode": true,
  "currency": "MXN", "created_at": 5123, "payment_method":{
  "id": "jkhhkhuayuqo12jda", "type":"oxxo", "created_at":12312,
  "last4": "8792", "name":"cash", "exp_month": "12", "exp_year": "1201",
  "brand": "breand", "parent_id": "haeui26ay74iak",
  "address":{ "street1": "23 green", "city": "Merida", "state": "Califonia",
  "postal_code": "97189", "country":"USA", "residential": false }
  } }`;
JSONValue j = parseJSON(strin);
Charge c = jsonToStructure!Charge(j); 
assert(c.id=="589026bbedbb6e56430016ad");
assert(c.status=="pending_payment");
assert(c.payment_method.brand=="breand");
assert(c.payment_method.created_at==12312);
}

struct Charges{

  //string object;
  bool has_more;
  int total;
  Charge[] data;
}
unittest{

string strin=`{ "data": [ { "id": "589026bbedbb6e56430016ad", 
  "status": "pending_payment", "amount": 12, 
  "fee": 97189, "order_id":"ord_2fw8EWJusiRrxdPzT", "livemode": true,
  "currency": "MXN", "created_at": 5123, "payment_method":{
  "id": "jkhhkhuayuqo12jda", "type":"oxxo", "created_at":12312433,
  "last4": "8792","name":"cash", "exp_month": "12", "exp_year": "1201",
  "brand": "breand", "parent_id": "haeui26ay74iak",
  "address":{ "street1": "23 green", "city": "Merida", "state": "Califonia",
  "postal_code": "97189", "country":"USA", "residential": false }
  } } ], "has_more": false, "total":1 }`;
JSONValue j = parseJSON(strin);
Charges c = jsonToStructure!Charges(j); 
assert(c.data[0].id=="589026bbedbb6e56430016ad");
assert(c.data[0].status=="pending_payment");
assert(c.data[0].order_id=="ord_2fw8EWJusiRrxdPzT");
assert(c.data[0].amount==12);
assert(c.has_more==false);
assert(c.total==1);
}

struct LineItem{

  string id;
  //string object;
  string name;
  string description;
  int unit_price;
  int quantity;
  string parent_id;
  string sku;
  string brand;
  //tags
  //antifraud_info = {},
  //metadata = {}

}
unittest{

string strin=`{ "id": "ship_cont_2fww6ojquQSVXFKzc", 
  "name": "cola", "description": "refresco", 
  "unit": 97189, "parent_id":"ord_2fw8EWJusiRrxdPzT", "sku": "nnas",
  "brand": "brand", "quantity": 5 }`;
JSONValue j = parseJSON(strin);
LineItem c = jsonToStructure!LineItem(j); 
assert(c.id=="ship_cont_2fww6ojquQSVXFKzc");
assert(c.name=="cola");
assert(c.description=="refresco");
assert(c.quantity==5);
}

struct LineItems{

  //string object;
  bool has_more;
  int total;
  LineItem[] data;

}
unittest{

string strin=`{ "data": [ { "id": "ship_cont_2fww6ojquQSVXFKzc", 
  "name": "cola", "description": "refresco", 
  "unit": 97189, "parent_id":"ord_2fw8EWJusiRrxdPzT", "sku": "nnas",
  "brand": "brand", "quantity": 5 } ],
  "has_more": false, "total": 1 }`;
JSONValue j = parseJSON(strin);
LineItems c = jsonToStructure!LineItems(j); 
assert(c.data[0].id=="ship_cont_2fww6ojquQSVXFKzc");
assert(c.data[0].name=="cola");
assert(c.data[0].description=="refresco");
assert(c.data[0].quantity==5);
assert(c.has_more==false);
assert(c.total==1);
}

struct ShipingLine {


  string id;
  int amount;
  string carrier;
  string method;
  // metadata={
    // some_random=Stuff
  // },
  //string object;
  string tracking_number;

}


unittest{

string strin=` { "id": "ship_lin_2fx13Ko8eXP79gQgg", 
  "method": "paid", "carrier": "USPS", 
  "amount": 97189,
  "tracking_number": "TRACK124" } `;
JSONValue j = parseJSON(strin);
ShipingLine c = jsonToStructure!ShipingLine(j); 
assert(c.id=="ship_lin_2fx13Ko8eXP79gQgg");
assert(c.carrier=="USPS");
assert(c.tracking_number=="TRACK124");
assert(c.method=="paid");
assert(c.amount==97189);
}

struct ShippingContacts {

  bool has_more;
  int total;
  //string object;
  ShippingContact[] data;
}
unittest{

string strin=`{ "data": [ { "id": "ship_cont_2fww6ojquQSVXFKzc", 
  "parent_id": "cus_2fd4nHfkDdNx19jWx", "receiver": "Diego", 
  "created_at": 97189, "phone":"+5218181818181", "between_streets": "",
  "address": { "street1": "23 green", "city": "Merida", "state": "Califonia",
  "postal_code": "97189", "country":"USA", "residential": false }  } ],
  "has_more": false, "total": 1 }`;
JSONValue j = parseJSON(strin);
ShippingContacts c = jsonToStructure!ShippingContacts(j); 
assert(c.data[0].id=="ship_cont_2fww6ojquQSVXFKzc");
assert(c.data[0].address.postal_code=="97189");
assert(c.data[0].address.country=="USA");
assert(c.data[0].parent_id=="cus_2fd4nHfkDdNx19jWx");
assert(c.has_more==false);
assert(c.total==1);
}


struct ShippingContact {

  string id;
  //string object;
  int created_at;
  string parent_id;
  string receiver;
  string phone;
  string between_streets;
  Address address;
}
unittest{

string strin=`{ "id": "ship_cont_2fww6ojquQSVXFKzc", 
  "parent_id": "cus_2fd4nHfkDdNx19jWx", "receiver": "Diego", 
  "created_at": 97189, "phone":"+5218181818181", "between_streets": "",
  "address": { "street1": "23 green", "city": "Merida", "state": "Califonia", 
  "postal_code": "97189", "country":"USA", "residential": false }  }`;
JSONValue j = parseJSON(strin);
ShippingContact c = jsonToStructure!ShippingContact(j); 
assert(c.id=="ship_cont_2fww6ojquQSVXFKzc");
assert(c.address.postal_code=="97189");
assert(c.address.country=="USA");
assert(c.parent_id=="cus_2fd4nHfkDdNx19jWx");
}


struct Address {

  string street1;
  string city;
  string state;
  string postal_code;
  string country;
  bool residential;
  //string object;
}
unittest{

string strin=`{ "street1": "23 green", "city": "Merida", "state": "Califonia", 
"postal_code": "97189", "country":"USA", "residential": false }`;
JSONValue j = parseJSON(strin);
Address c = jsonToStructure!Address(j); 
assert(c.residential==false);
assert(c.postal_code=="97189");
assert(c.country=="USA");
assert(c.city=="Merida");
}


struct DiscountLines {

  bool has_more;
  int total;
  //string object;
  DiscountLine[] data;
}
unittest{

string strin=`{ "has_more": false, "data":[ { "code": "2fwchSbbQ2hjADDUo", 
"type": "discount", "id": "dis_lin_2fwchSbbQ2hjADDUo", "amount": 121 } ], 
"total": 1 }`;
JSONValue j = parseJSON(strin);
DiscountLines c = jsonToStructure!DiscountLines(j); 
assert(c.has_more==false);
assert(c.total==1);
assert(c.data[0].code=="2fwchSbbQ2hjADDUo");
assert(c.data[0].type=="discount");
}

struct DiscountLine {

  string id;
  int amount;
  string code;
  string type;
  //string object;
}

unittest{

string strin=`{ "code": "2fwchSbbQ2hjADDUo", "type": "discount", 
"id": "dis_lin_2fwchSbbQ2hjADDUo", "amount": 121 }`;
JSONValue j = parseJSON(strin);
DiscountLine c = jsonToStructure!DiscountLine(j); 
assert(c.id=="dis_lin_2fwchSbbQ2hjADDUo");
assert(c.amount==121);
assert(c.code=="2fwchSbbQ2hjADDUo");
assert(c.type=="discount");
}

struct ConektaException {
  string debug_message;
  string message;
  string code;
}

struct MessageError {
  ConektaException[] details;
  string object;
  string type;
  string log_id;
}
