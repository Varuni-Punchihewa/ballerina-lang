import ballerina/io;

int add = 0;
int index = 0;

function testInt1() returns (int, int, int, int, int, float) {
    add = 0;
    int[] fa = [-5, 2, 4, 5, 7, -8, -3, 2];
    fa.foreach(function (int i) { add = add + i;});
    int fadd1 = add;
    int count = fa.count();
    int max = fa.max();
    int min = fa.min();
    int sum = fa.sum();
    float avg = fa.average();
    return (fadd1, count, max, min, sum, avg);
}

function testInt2() returns (int, int, int, int, float) {
    int[] fa = [-5, 2, 4, 5, 7, -8, -3, 2];
    int count = fa.filter(filterIntNegative).count();
    int max = fa.filter(filterIntNegative).max();
    int min = fa.filter(filterIntNegative).min();
    int sum = fa.filter(filterIntNegative).sum();
    float avg = fa.filter(filterIntNegative).average();
    return (count, max, min, sum, avg);
}

function filterIntNegative(int i) returns boolean {
    return i >= 0;
}

float fadd = 0;
function testFloat1() returns (float, int, float, float, float, float){
    fadd = 0.0;
    float[] fa = [1.1, 2.2, -3.3, 4.4, 5.5];
    fa.foreach(function (float i) { fadd = fadd + i;});
    float fsum = fadd;
    int count = fa.count();
    float max = fa.max();
    float min = fa.min();
    float sum = fa.sum();
    float avg = fa.average();
    return (fsum, count, max, min, sum, avg);
}

function testFloat2() returns (int, float, float, float, float){
    float[] fa = [1.1, 2.2, -3.3, 4.4, 5.5];
    int count = fa.filter(filterFloatNegative).count();
    float max = fa.filter(filterFloatNegative).max();
    float min = fa.filter(filterFloatNegative).min();
    float sum = fa.filter(filterFloatNegative).sum();
    float avg = fa.filter(filterFloatNegative).average();
    return (count, max, min, sum, avg);
}

function filterFloatNegative(float i) returns boolean {
    return i >= 0;
}

string output = "";

function testBasicArray1(string[] values) returns string {
    output = "";
    values.map(mapString).foreach(concat);
    return output.trim();
}

function mapString(string x) returns (string, string) {
    string up = x.toUpper();
    string lower = x.toLower();
    return (up, lower);
}

function concat((string, string) value) {
    var (up, lower) = value;
    output = output + " " + up + ":" + lower;
}

function testBasicArray2(string[] values) returns string {
    output = "";

    index = 0;
    values.map(function (string s) returns string {
                    var value = string.convert(index) + s;
                    index += 1;
                    return value;
               })
    .foreach(function (string s) {
                 output = output + s + " ";
             });
    return output.trim();
}

function testBasicMap1() returns (int, string[]) {
    map<string> m = {a:"A", b:"B", c:"C", d:"D", e:"E"};
    int count = m.count();
    string[] values = m.map(function ((string, string) value) returns string {
                                var (k, v) = value;
                                return k.toLower();
                            })
                      .filter(function (string v) returns boolean {
                                  if (v == "a" || v == "e") {
                                      return true;
                                  }
                                  return false; });
    return (count, values);
}

function testBasicMap2() returns string[] {
    map<string> m = {a:"A", b:"B", c:"C", d:"D", e:"E"};
    string[] values = m.map(mapToTuple)
                      .filter(function ((string, string) v) returns boolean {
                                  var (k, t) = v;
                                  if (k == "a" || k == "e") {
                                      return true;
                                  }
                                  return false; })
                      .map(concatString);
    return values;
}

function mapToTuple((string, string) tuple) returns (string, string) {
    var (key, value) = tuple;
    return (key, value);
}

function concatString((string, string) v) returns string {
    var (v1, v2) = v;
    return v1 + v2;
}

function xmlTest() returns (int, int, map<any>) {
    xml xdata = xml `<p:person xmlns:p="foo" xmlns:q="bar">
        <p:name>bob</p:name>
        <p:address>
            <p:city>NY</p:city>
            <q:country>US</q:country>
        </p:address>
        <q:ID>1131313</q:ID>
    </p:person>`;
    int nodeCount = xdata.*.count();
    int elementCount = xdata.*.elements().count();

    index = -1;
    map<xml> m = xdata.*.elements()[1].*.elements()
                 .map(function (xml|string x) returns (string, xml) {
                            index += 1;
                            if x is xml {
                                return (string.convert(index), x);
                            }
                            return ("", xml ` `);
                      });
    return (nodeCount, elementCount, m);
}

type person record {
    string name;
    int age;
};

function structTest() returns (int, string[]) {
    person bob = {name:"bob", age:30};
    person tom = {name:"tom", age:20};
    person sam = {name:"sam", age:24};
    person[] p = [bob, tom, sam];
    int count = p.filter(isBellow25).count();
    string[] names = p.map(getName);
    return (count, names);
}

function getName(person p) returns string {
    return p.name;
}

function isBellow25(person p) returns boolean {
    return p.age < 25;
}

function testIgnoredValue() returns (string) {
    output = "";
    string[] s = ["abc", "cd", "pqr"];
    _ = s.filter(function (string ss) returns boolean {return ss.length() == 3;})
    .map(function (string ss) returns string {
            output = output + " " + ss;
            return (ss + ss);
             });
    return output.trim();
}

function appendAny(any a) {
    var s = <string>a;
    output = s;
}

function testInExpression() returns (string, int) {
    output = "";
    string[] s = ["abc", "cd", "pqr"];
    float[] r = [1.1, -2.2, 3.3, 4.4];
    appendAny("total count " + s.filter(function (string ss) returns boolean {return ss.length() == 3;}).count());
    int i = s.count() + r.count();
    return (output, i);
}

function testInFunctionInvocation() returns int {
    map<string> m = {a:"abc", b:"cd", c:"pqr"};
    return doubleInt(m.filter(function ((string, string) value) returns boolean {
                                  var (k, v) = value;
                                  int i = v.length();
                                  return i == 3;})
                     .count());
}

function doubleInt(int i) returns int {
    return i * 2;
}

function testInStatement() returns int {
    map<string> m = {a:"abc", b:"cd", c:"pqr"};
    if (5 > m.filter(function ((string, string) value) returns boolean {
                         var (k, v) = value;
                         return v.length() == 3;})
            .count()) {
        return 10;
    }
    return 0;
}

function testIterableOutputPrint() returns (any, any, any, any, any) {
    map<string> m = {a:"abc", b:"cd", c:"pqr"};
    any count = m.count();
    foo(count);
    foo(m.count());

    int[] a = [-5, 2, 4, 5, 7, -8, -3, 2];

    foo(a.average());
    any b = a.average();
    foo(b);

    foo(a.min());
    any c = a.min();
    foo(c);

    foo(a.max());
    any d = a.max();
    foo(d);

    foo(a.sum());
    any e = a.sum();
    foo(e);

    return (count, b, c, d, e);
}

function foo(any a) {
    //do nothing
}

function testIterableReturnLambda() returns (function (int) returns boolean)[] {

    map<string> words = { a: "ant", b: "bear", c: "tiger"};

    (function (int) returns boolean)[] lambdas = words.map(function ((string, string) input) returns (function (int) returns boolean) {
        return function (int param) returns boolean {
            return true;
        };
    });

    return lambdas;
}
