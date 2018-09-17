/**
 * OpenAPI Petstore
 * This spec is mainly for testing Petstore server and contains fake endpoints, models. Please do not use this for any other purpose. Special characters: \" \\
 *
 * The version of the OpenAPI document: 1.0.0
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 *
 * OpenAPI Generator version: 4.2.1
 *
 * Do not edit the class manually.
 *
 */

(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define(['ApiClient', 'model/Animal', 'model/DogAllOf'], factory);
  } else if (typeof module === 'object' && module.exports) {
    // CommonJS-like environments that support module.exports, like Node.
    module.exports = factory(require('../ApiClient'), require('./Animal'), require('./DogAllOf'));
  } else {
    // Browser globals (root is window)
    if (!root.OpenApiPetstore) {
      root.OpenApiPetstore = {};
    }
    root.OpenApiPetstore.Dog = factory(root.OpenApiPetstore.ApiClient, root.OpenApiPetstore.Animal, root.OpenApiPetstore.DogAllOf);
  }
}(this, function(ApiClient, Animal, DogAllOf) {
  'use strict';



  /**
   * The Dog model module.
   * @module model/Dog
   * @version 1.0.0
   */

  /**
   * Constructs a new <code>Dog</code>.
   * @alias module:model/Dog
   * @class
   * @extends module:model/Animal
   * @implements module:model/Animal
   * @implements module:model/DogAllOf
   * @param className {String} 
   */
  var exports = function(className) {
    var _this = this;

    Animal.call(_this, className);
  };

  /**
   * Constructs a <code>Dog</code> from a plain JavaScript object, optionally creating a new instance.
   * Copies all relevant properties from <code>data</code> to <code>obj</code> if supplied or a new instance if not.
   * @param {Object} data The plain JavaScript object bearing properties of interest.
   * @param {module:model/Dog} obj Optional instance to populate.
   * @return {module:model/Dog} The populated <code>Dog</code> instance.
   */
  exports.constructFromObject = function(data, obj) {
    if (data) {
      obj = obj || new exports();
      Animal.constructFromObject(data, obj);
      if (data.hasOwnProperty('breed')) {
        obj['breed'] = ApiClient.convertToType(data['breed'], 'String');
      }
    }
    return obj;
  }

  exports.prototype = Object.create(Animal.prototype);
  exports.prototype.constructor = exports;

  /**
   * @member {String} breed
   */
  exports.prototype['breed'] = undefined;

  // Implement Animal interface:
  /**
   * @member {String} className
   */
exports.prototype['className'] = undefined;

  /**
   * @member {String} color
   * @default 'red'
   */
exports.prototype['color'] = 'red';

  // Implement DogAllOf interface:
  /**
   * @member {String} breed
   */
exports.prototype['breed'] = undefined;



  return exports;
}));


