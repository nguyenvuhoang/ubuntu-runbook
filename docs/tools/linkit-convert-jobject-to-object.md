# Convert JObject to Plain Object with LinKit

## Situation

In some API controller responses, the handler result may contain data built from `JObject` or dynamic JSON objects.

When returning it directly from ASP.NET Core:

```csharp
return Ok(result);
```

The response can sometimes serialize in an unexpected shape, especially when the client expects a normal plain object response.

## Temporary Fix

Use LinKit JSON extension methods to convert the result into a normal object before returning the response:

```csharp
var response = result.ToJson().FromJson<object>();

return Ok(response);
```

Important: do this **after** checking business success/error status.

## Controller Example

```csharp
using LinKit.Core.Cqrs;
using Microsoft.AspNetCore.Mvc;
using O24OpenAPI.APIContracts.Constants;
using O24OpenAPI.CBG.API.Application.CBS.O9.Common;
using O24OpenAPI.CBG.API.Application.Features.Coregateway;
using O24OpenAPI.CBG.API.AttributeController;
using O24OpenAPI.Framework.Attributes;
using O24OpenAPI.Framework.Utils;
// Add the correct LinKit extension namespace used by the solution
// using LinKit.Core.Extensions;

namespace O24OpenAPI.CBG.API.Controllers;

public class CoregatewayController([FromKeyedServices(MediatorKey.CBG)] IMediator mediator) : BaseCoregatewayController
{
    /// <summary>
    /// Post
    /// </summary>
    /// <param name="request">.</param>
    /// <returns>IActionResult.</returns>
    [HttpPost]
    [SkipResponseWrapper]
    public virtual async Task<IActionResult> Post(
        [FromBody] CoregatewayPostCommand request,
        CancellationToken cancellationToken = default
    )
    {
        var token = HttpContext.Items["authorization"]?.ToString();
        if (string.IsNullOrEmpty(token))
        {
            return Unauthorized(Codetypes.Err_Unauthorized);
        }

        var header = HttpUtils.GetHeaders(HttpContext);

        request.Token = token;
        request.Header = header;

        var result = await mediator.SendAsync(request, cancellationToken);

        if (!result.IsSuccess())
        {
            var error = new CodeDescription
            {
                ERRORCODE = result.ErrorCode,
                ERRORDESC = result.ErrorDescription,
                ERRORNAME = result.ErrorName,
                ERRORSOURCE = result.ErrorSource
            };

            return StatusCode(StatusCodes.Status500InternalServerError, error);
        }

        // Temporary conversion from JObject/dynamic JSON result to plain object
        var response = result.ToJson().FromJson<object>();

        return Ok(response);
    }
}
```

## Why Convert After `IsSuccess()`?

`result` still needs its original type while checking:

- `result.IsSuccess()`
- `result.ErrorCode`
- `result.ErrorDescription`
- `result.ErrorName`
- `result.ErrorSource`

If the object is converted too early, these helper methods and typed properties may be lost.

## Notes

- This is a temporary compatibility fix.
- The better long-term approach is to return a strongly typed response model from the handler.
- If the compiler cannot find `ToJson()` or `FromJson<T>()`, add the correct LinKit extension namespace used in the project.
