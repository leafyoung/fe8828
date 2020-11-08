
# coding: utf-8

# In[180]:


# simple variable
a = 1
print(a)
print(range(3))
print([1, 2, 3])

# array
a = [1, 2, 3, 3]
a[1]
len(a)
a.count(3)
a.insert(2, 2)
print(a)


# In[181]:


# string
b = "MFE"
print(b)
b.find("Z")
b[b.find("F")]

# v <- 1:10, v[v == 3]


# In[182]:


# dictionary
orderBook = {} # initilization, first-time use of a variable
orderBook[110] = [1, 2]
print(orderBook[110])
# print(orderBook[111])
orderBook[110] = [2, 3]
print(orderBook[110])


# In[183]:


orderBook = {110 : [1, 2], 111: [2,3]}

orderBook = {}
orderBook[110] = [1, 2]
orderBook[111] = [2, 3]



# In[184]:


import string
"abc".capitalize()
print('{1}, {0}, {1}'.format(1, "MFE", 3.14159))


# In[185]:


if 3 < 1:
  print("3>1")
  print("3>2")
elif 5 < 3:
  print("5>3")
else:
  print("there")
a = 3


# In[186]:


# 1 to 9
for i in range(1, 10):
    print(i)

# 0 to 9
for i in range(10):
    print(i)

fruits = ["a", "b", "c"]
for f in fruits:
    print(f)
    
# ....


# In[187]:


def isNeg(x):
    return(x < 0)

print("-1: {0} 1: {1} 0: {2}".format(isNeg(-1), isNeg(1), isNeg(0)))

def doSomething(x):
    pass

doSomething("sdfdf")


# In[188]:


class OO:
    def __init__(self):
        self.orders = {}

oo = OO()
print(oo.orders)


# In[189]:


from string import *
  
def findElem(l,x):
    for elem in l:
        if elem == x:
            return True
    return False

# dictionary: price and qty
orderBook1 = { 110 : [1,2], 105 : [1,3,5]}

orderBook1[95] = [1]

orderBook1[110].append(10)
orderBook1[110].append(10)

# orderBook1{ 95: [1], 110 : [1,2, 10, 10], 105 : [1,3,5]}

orderBook1[110].append(4)

if findElem(orderBook1[110], 4):
    print("run here")
    orderBook1[110].remove(4)

# orderBook1[105].remove(2)

for p in orderBook1:
    print(p, orderBook1[p])

priceQueue = [[], [1,2], [1,3,5], []]
priceList = [-10, 110, 105, 11000]


# In[190]:


orders = {101: [10]}
print(orders[101])
orders[101].extend([1])
print(orders[101])

orders[95] = [1, 3]
print(orders[95])

101 in orders.keys()
print(orders)




# In[191]:


class OrderBook:
    def __init__(self, initOrder = {}):
        self.orders = initOrder

    def print(self):
        for p in self.orders:
            print(p, self.orders[p])

    def count(self):
        sum = 0
        for p in self.orders:
            for x in self.orders[p]:
                sum = sum + x
        return(sum)

    def count_n(self):
        sum = 0
        for p in self.orders:
            sum = sum + len(self.orders[p])
        return(sum)
    
    def addOrder(self, price, orders):
        # use self. to refer self variable.
        if price in self.orders.keys():
            # key already exists in the dictionary
            self.orders[price].extend(orders)
        else:
            # key not exists in the dictionary
            self.orders[price] = orders

    def removeOrder(self, price, order):
        # use self. to refer self variable.
        if price in self.orders.keys():
            # key already exists in the dictionary
            if self.orders[price].count(order) >= 0:
                self.orders[price].remove(order)
            
            
ob = OrderBook({100: [1, 2]})
ob.print()

print("------")

ob.orders[110] = [1, 2]
ob.orders[110] = [1, 2]
ob.orders[95] = [2, 3]

ob.print()
print(ob.count())
print(ob.count_n())
print("------")
ob.addOrder(80, [1, 3])
ob.print()
print("------")
ob.removeOrder(80, 3)
ob.print()


# In[192]:


class OrderBookV1:
    orders = {}
    numberOrder = 0
    
    def __init__(self, initOrder = {}):
        self.orders = initOrder

    def print(self):
        for p in self.orders:
            print(p, self.orders[p])

class OrderBookV2:
    orders = {}
    numberOrder = 0
    
    def __init__(self, initOrder = {}):
        self.orders = initOrder

    def print(self):
        for p in self.orders:
            print(p, self.orders[p])

    def count(self):
        sum = 0
        for p in self.orders:
            for x in self.orders[p]:
                sum = sum + x
        return(sum)

    def count_n(self):
        sum = 0
        for p in self.orders:
            sum = sum + len(self.orders[p])
        return(sum)
    
class OrderBookV3:
    orders = {}
    numberOrder = 0
    
    def __init__(self, initOrder = {}):
        self.orders = initOrder

    def print(self):
        for p in self.orders:
            print(p, self.orders[p])

    def count(self):
        sum = 0
        for p in self.orders:
            for x in self.orders[p]:
                sum = sum + x
        return(sum)

    def count_n(self):
        sum = 0
        for p in self.orders:
            sum = sum + len(self.orders[p])
        return(sum)  
    
    def addOrder(self, price, orders):
        # use self. to refer self variable.
        if price in self.orders.keys():
            # key already exists in the dictionary
            self.orders[price].extend(orders)
        else:
            # key not exists in the dictionary
            self.orders[price] = orders

    def removeOrder(self, price, order):
        # use self. to refer self variable.
        if price in self.orders.keys():
            # key already exists in the dictionary
            if self.orders[price].count(order) >= 0:
                self.orders[price].remove(order)
            


# In[193]:


# Dim CashFlow(1 to 3, 1 to 10) as Variant

class SingleCF:
    time = 0
    discount = 0.123
    FV = 10000
    
    def __init__(self, time, discount, FV):
        self.time = time
        self.discount = discount
        self.FV = FV

    def PV(self):
        return(self.discount * self.FV)
    
class CashFlow:
    cf = [SingleCF(0.5, 0.12, 1000),
          SingleCF(1, 0.124, 1000),
          SingleCF(1.5, 0.124, 1000)]
    
    def PV(self):
        sum = 0
        for f in self.cf:
            sum = sum + f.PV()
        return(sum)


    


# In[194]:


a = "this is a string"
a = 11233

a = []
a.append(1.0)
a.append(2.0)

mymap = {}
mymap['a'] = 1
mymap['b'] = 2

# map:
#     'a' => 1 => "Iterator"
#    'b' => 2

for it in mymap:
    print(it, mymap[it])

key = 3
if key in mymap.keys():
    mymap.remove(key)
    
class BS:
    def __init__(self, price, strike, r):
        self.price = price
        self.strike = strike
        self.r = r
    

