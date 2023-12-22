import * as params from '@params';
document.addEventListener('DOMContentLoaded', function () {
    Coveo.SearchEndpoint.configureCloudV2Endpoint("", params.coveokey);
    const root = document.getElementById("search");
    const searchBoxRoot = document.getElementById("searchbox");
    Coveo.initSearchbox(searchBoxRoot, "/search.html");
    var resetbtn = document.querySelector('#reset_btn');
    if (resetbtn) {
      resetbtn.onclick = function () {
        document.querySelector('.coveo-facet-header-eraser').click();
      };
    }
    Coveo.$$(root).on("querySuccess", function (e, args) {
      resetbtn.style.display = "block";
    });
    Coveo.$$(root).on('afterComponentsInitialization', function (e, data) {
      setTimeout(function () {
        document.querySelector('.CoveoOmnibox input').value = Coveo.state(root, 'q');
      }, 1000);
    });
    Coveo.$('#search').on("newResultsDisplayed", function (e, args) {
      for (var i = 0; i < e.target.lastChild.children.length; i++) {
        //Remove the title for tooltip box  
        Coveo.$('.CoveoResultLink').removeAttr('title');         
      }
    });
    Coveo.init(root, {
      f5_product_module: {
        dependsOn: "@f5_product",
        dependsOnCondition: (parentFacet) => {
          const id = parentFacet.options.id;
          const value = "NGINX Management Suite";
          const selected = parentFacet.queryStateModel.get(`f:${id}`)
          return selected.includes(value);
        }
      }
    });
  })
  
  