
# Postman Setup for Testing Backend Stub and Emulator  
*(Example with Petstore Swagger API)*

---

## 1. Setup Environment Variables

Create a Postman environment with variables:

| Variable  | Initial Value                   | Current Value                   |
| --------- | ------------------------------ | ------------------------------ |
| base_url  | https://petstore.swagger.io/v2 | https://petstore.swagger.io/v2 |
| useStub   | true                           | true                           |

---

## 2. Example Request

Create a GET request to fetch a pet by ID=1:

```

GET {{base\_url}}/pet/1

````

---

## 3. Pre-request Script to Enable Stub

Add this script to the **Pre-request Script** tab to automatically add a header and query parameter to enable the stub, if `useStub` is `"true"`:

```javascript
const useStub = pm.environment.get("useStub");
let url = pm.request.url;

if (useStub === "true") {
    if (!pm.request.headers.has('X-Use-Stub')) {
        pm.request.headers.add({ key: 'X-Use-Stub', value: 'true' });
    }
    const hasUseStubParam = url.query.some(param => param.key === 'useStub');
    if (!hasUseStubParam) {
        url.addQueryParams({ key: 'useStub', value: 'true' });
        pm.request.url = url;
    }
}
````


## 4. Test Script to Verify Stub Response

Add this script to the **Tests** tab to verify that the response is coming from the stub/emulator:

```javascript
pm.test("Status code is 200", () => {
    pm.response.to.have.status(200);
});

// Check for a header indicating stub response (adjust as per your backend)
pm.test("Response is from stub/emulator", () => {
    pm.expect(pm.response.headers.get("X-Mock-Source")).to.eql("stub");
});

// Check JSON body for stub flag or test data (adjust fields accordingly)
const jsonData = pm.response.json();

pm.test("Stub flag is true", () => {
    pm.expect(jsonData.isMock).to.be.true;
});

pm.test("Stub user name is 'Stub User'", () => {
    pm.expect(jsonData.name).to.eql("Stub User");
});
```

> **Note:** Customize header names, JSON fields, and expected values based on your backend stub/emulator implementation.

---

## 5. How to Use

* Set environment variable `useStub` to `"true"` to enable stub mode.
* Send requests — the pre-request script will add `X-Use-Stub: true` header and `useStub=true` query parameter.
* Test scripts will confirm that the response is from the stub.
* Switch `useStub` to `"false"` or remove it to test the real backend.

