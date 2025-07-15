# Mini Deal Marketplace (Intermediate LWC + Apex)

This repository contains two custom Lightning Web Components (LWC) built on the Salesforce Platform to manage deals.

---

##  Data Setup Table

**Custom Object:** `Deal__c`

> While creating new fields:
> - Fields should be visible to profiles: **System Administrator** and **Standard User**
> - Add all fields to the **Deal layout**

| Label         | API Name          | Type      | Details                                      |
|---------------|-------------------|-----------|----------------------------------------------|
| Deal Name     | Name              | Text      | Standard Field                               |
| Price         | Price__c          | Currency  | **Required**                                 |
| Status        | Status__c         | Picklist  | Values: Available, Interested, Closed        |
| Category      | Category__c       | Picklist  | Values: Electronics, Books, Furniture, Others|
| Is Promoted   | Is_Promoted__c    | Checkbox  | Default: **False**                           |
| Owner         | OwnerId           | Lookup    | Standard Field                               |
| Created Date  | CreatedDate       | DateTime  | Standard Field                               |

---

##  1. `dealBrowser` Component

Displays **all available deals** to users in a **card layout** with filters and pagination.

###  Features:
- **Category Filter** using a dropdown
- **Price Range Filter**: Minimum and Maximum price
- **Pagination** for navigating deals
- Each card shows:
  - Name
  - Category
  - Price
  - Status
- **“Show Interest”** button (visible if Status = `Available`)
  - On-click: Updates deal status to `Interested` via Apex
  - Displays **success/failure toast**

---
## Add component on Home page 
 
Go to Sales Home page -> Click on **gear icon** -> Edit Page 

Click on **Pages** -> **new pages** -> Enter Name - `New Home Page` and select template as **Standard Home Page** 

Drag the custom lwc component – `dealBrowser` to **New Home Page** 

Click on **Activation** -> go to **App and Profile** section -> **Add Assignments** 

For lightning apps select `Sales` -> for profile select `System Administrator` 

Click Save. 

---
##  Apex Classes & Test Classes

Each component is supported by its Apex controller and test class.

| Component     | Controller Class           | Test Class                 |
|---------------|----------------------------|----------------------------|
| dealBrowser   | `DealBrowserController`    | `DealBrowserControllerTest`|

---

##  2. `myDeals` Component

Displays **all deals created by the logged-in user** with inline editing features.

###  Features:
- Inline editing of:
  - `Price`
  - `Status`
- Promoted deals highlighted with an icon
- Ownership check ensures users **only see and edit their own deals**

---
## Add Tab on Sales App 

Click on `gear icon` -> Go to **Setup** -> Search for **Tabs** -> open Tabs setting 

Click on New for Custom Object Tabs -> Select Object – `Deal` -> Select a **Tab Style** 

Save
---
## Adding component on Deal Tab 

Go to **Deal Tab** ->-> Click on `gear icon` -> Edit Page 

Click on **Pages** -> new pages -> Enter Name - `myDeals` and select **template** as `One Region` 

Drag the custom lwc component – `myDeals` to **myDeals Page** 

Click on **Activation** -> go to Lightning Experience -> Select `Sales` 

Click **Save**. 

---
##  Apex Classes & Test Classes

Each component is supported by its Apex controller and test class.

| Component     | Controller Class           | Test Class                 |
|---------------|----------------------------|----------------------------|
| myDeals       | `MyDealsController`        | `MyDealsControllerTest`    |

---

##  Field-Level Security (FLS) via Permission Set

Create a **Permission Set** named `Deal_Access`:

1. Go to **Setup → Permission Sets**
2. Click **New**
   - **Label:** Deal_Access
3. Under **Object Settings**, search for **Deal**
4. **Edit** and grant:
   - **Read/Edit** access for fields:
     - `Price__c`
     - `Status__c`
     - `Is_Promoted__c`
     - `Category__c`
5. Go to **Manage Assignments** to assign users

---

##  Custom Labels

Create the following custom labels in **Setup → Custom Labels → New Custom Label**:

| Name                    | Value        |
|-------------------------|--------------|
| `PICKLISTVAL_AVAILABLE` | Available    |
| `PICKLISTVAL_INTERESTED`| Interested   |
| `PICKLISTVAL_CLOSED`    | Closed       |
| `CATEGORY_ELECTRONICS`  | Electronics  |
| `CATEGORY_BOOKS`        | Books        |
| `CATEGORY_FURNITURE`    | Furniture    |
| `CATEGORY_OTHERS`       | Others       |

---


Happy Coding! 🎉
