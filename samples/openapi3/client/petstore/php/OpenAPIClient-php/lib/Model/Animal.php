<?php
/**
 * Animal
 *
 * PHP version 5
 *
 * @category Class
 * @package  OpenAPI\Client
 * @author   OpenAPI Generator team
 * @link     https://openapi-generator.tech
 */

/**
 * OpenAPI Petstore
 *
 * This spec is mainly for testing Petstore server and contains fake endpoints, models. Please do not use this for any other purpose. Special characters: \" \\
 *
 * The version of the OpenAPI document: 1.0.0
 * 
 * Generated by: https://openapi-generator.tech
 * OpenAPI Generator version: 4.2.1
 */

/**
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */

namespace OpenAPI\Client\Model;

use \ArrayAccess;
use \OpenAPI\Client\ObjectSerializer;

/**
 * Animal Class Doc Comment
 *
 * @category Class
 * @package  OpenAPI\Client
 * @author   OpenAPI Generator team
 * @link     https://openapi-generator.tech
 */
class Animal implements ModelInterface, ArrayAccess
{
    const DISCRIMINATOR = 'class_name';

    /**
      * The original name of the model.
      *
      * @var string
      */
    protected static $openAPIModelName = 'Animal';

    /**
      * Array of property to type mappings. Used for (de)serialization
      *
      * @var string[]
      */
    protected static $openAPITypes = [
        'class_name' => 'string',
        'color' => 'string'
    ];

    /**
      * Array of property to format mappings. Used for (de)serialization
      *
      * @var string[]
      */
    protected static $openAPIFormats = [
        'class_name' => null,
        'color' => null
    ];

    /**
      * Array of nullable properties. Used for (de)serialization
      *
      * @var boolean[]
      */
    protected static $openAPINullables = [
        'class_name' => false,
        'color' => false
    ];

    /**
      * If a nullable field gets set to null, insert it here
      *
      * @var boolean[]
      */
    protected $openAPINullablesSetToNull = [];

    /**
     * Array of property to type mappings. Used for (de)serialization
     *
     * @return array
     */
    public static function openAPITypes()
    {
        return self::$openAPITypes;
    }

    /**
     * Array of property to format mappings. Used for (de)serialization
     *
     * @return array
     */
    public static function openAPIFormats()
    {
        return self::$openAPIFormats;
    }

    /**
     * Array of property to nullable mappings. Used for (de)serialization
     *
     * @return array
     */
    public static function openAPINullables()
    {
        return self::$openAPINullables;
    }

    /**
     * Array of nullable field names deliberately set to null
     *
     * @return array
     */
    public function getOpenAPINullablesSetToNull()
    {
        return $this->openAPINullablesSetToNull;
    }

    public function setOpenAPINullablesSetToNull($nullablesSetToNull)
    {
        $this->openAPINullablesSetToNull=$nullablesSetToNull;

        return $this;
    }

    /**
     * Checks if a property is nullable
     *
     * @return bool
     */
    public static function isNullable(string $property): bool
    {
        if (isset(self::$openAPINullables[$property])) {
            return self::$openAPINullables[$property];
        }

        return false;
    }

    /**
     * Checks if a nullable property is set to null.
     *
     * @return bool
     */
    public function isNullableSetToNull(string $property): bool
    {
        if (in_array($property, $this->getOpenAPINullablesSetToNull())) {
            return true;
        }
        return false;
    }

    /**
     * Array of attributes where the key is the local name,
     * and the value is the original name
     *
     * @var string[]
     */
    protected static $attributeMap = [
        'class_name' => 'className',
        'color' => 'color'
    ];

    /**
     * Array of attributes to setter functions (for deserialization of responses)
     *
     * @var string[]
     */
    protected static $setters = [
        'class_name' => 'setClassName',
        'color' => 'setColor'
    ];

    /**
     * Array of attributes to getter functions (for serialization of requests)
     *
     * @var string[]
     */
    protected static $getters = [
        'class_name' => 'getClassName',
        'color' => 'getColor'
    ];

    /**
     * Array of attributes where the key is the local name,
     * and the value is the original name
     *
     * @return array
     */
    public static function attributeMap()
    {
        return self::$attributeMap;
    }

    /**
     * Array of attributes to setter functions (for deserialization of responses)
     *
     * @return array
     */
    public static function setters()
    {
        return self::$setters;
    }

    /**
     * Array of attributes to getter functions (for serialization of requests)
     *
     * @return array
     */
    public static function getters()
    {
        return self::$getters;
    }

    /**
     * The original name of the model.
     *
     * @return string
     */
    public function getModelName()
    {
        return self::$openAPIModelName;
    }

    

    

    /**
     * Associative array for storing property values
     *
     * @var mixed[]
     */
    protected $container = [];

    /**
     * Constructor
     *
     * @param mixed[] $data Associated array of property values
     *                      initializing the model
     */
    public function __construct(array $data = null)
    {
        $this->setIfExists('class_name', $data, null);
        $this->setIfExists('color', $data, 'red');

        // Initialize discriminator property with the model name.
        $this->container['class_name'] = static::$openAPIModelName;
    }

    public function setIfExists(string $variableName, $fields, $defaultValue)
    {
        if (is_array($fields) && array_key_exists($variableName, $fields) && is_null($fields[$variableName]) && self::isNullable($variableName)) {
            array_push($this->openAPINullablesSetToNull, $variableName);
        }

        $this->container[$variableName] = isset($fields[$variableName]) ? $fields[$variableName] : $defaultValue;

        return $this;
    }

    /**
     * Show all the invalid properties with reasons.
     *
     * @return array invalid properties with reasons
     */
    public function listInvalidProperties()
    {
        $invalidProperties = [];

        if ($this->container['class_name'] === null) {
            $invalidProperties[] = "'class_name' can't be null";
        }
        return $invalidProperties;
    }

    /**
     * Validate all the properties in the model
     * return true if all passed
     *
     * @return bool True if all properties are valid
     */
    public function valid()
    {
        return count($this->listInvalidProperties()) === 0;
    }


    /**
     * Gets class_name
     *
     * @return string
     */
    public function getClassName()
    {
        return $this->container['class_name'];
    }

    /**
     * Sets class_name
     *
     * @param string $class_name class_name
     *
     * @return $this
     */
    public function setClassName($class_name)
    {

        if (is_null($class_name)) {
            throw new \InvalidArgumentException('non-nullable class_name cannot be null');
        }

        $this->container['class_name'] = $class_name;

        return $this;
    }

    /**
     * Gets color
     *
     * @return string|null
     */
    public function getColor()
    {
        return $this->container['color'];
    }

    /**
     * Sets color
     *
     * @param string|null $color color
     *
     * @return $this
     */
    public function setColor($color)
    {

        if (is_null($color)) {
            throw new \InvalidArgumentException('non-nullable color cannot be null');
        }

        $this->container['color'] = $color;

        return $this;
    }
    /**
     * Returns true if offset exists. False otherwise.
     *
     * @param integer $offset Offset
     *
     * @return boolean
     */
    public function offsetExists($offset)
    {
        return isset($this->container[$offset]);
    }

    /**
     * Gets offset.
     *
     * @param integer $offset Offset
     *
     * @return mixed
     */
    public function offsetGet($offset)
    {
        return isset($this->container[$offset]) ? $this->container[$offset] : null;
    }

    /**
     * Sets value based on offset.
     *
     * @param integer $offset Offset
     * @param mixed   $value  Value to be set
     *
     * @return void
     */
    public function offsetSet($offset, $value)
    {
        if (is_null($offset)) {
            $this->container[] = $value;
        } else {
            $this->container[$offset] = $value;
        }
    }

    /**
     * Unsets offset.
     *
     * @param integer $offset Offset
     *
     * @return void
     */
    public function offsetUnset($offset)
    {
        unset($this->container[$offset]);
    }

    /**
     * Gets the string presentation of the object
     *
     * @return string
     */
    public function __toString()
    {
        return json_encode(
            ObjectSerializer::sanitizeForSerialization($this),
            JSON_PRETTY_PRINT
        );
    }

    /**
     * Gets a header-safe presentation of the object
     *
     * @return string
     */
    public function toHeaderValue()
    {
        return json_encode(ObjectSerializer::sanitizeForSerialization($this));
    }
}


