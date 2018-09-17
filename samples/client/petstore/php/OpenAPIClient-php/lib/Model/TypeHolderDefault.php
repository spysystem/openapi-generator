<?php
/**
 * TypeHolderDefault
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
 * TypeHolderDefault Class Doc Comment
 *
 * @category Class
 * @package  OpenAPI\Client
 * @author   OpenAPI Generator team
 * @link     https://openapi-generator.tech
 */
class TypeHolderDefault implements ModelInterface, ArrayAccess
{
    const DISCRIMINATOR = null;

    /**
      * The original name of the model.
      *
      * @var string
      */
    protected static $openAPIModelName = 'TypeHolderDefault';

    /**
      * Array of property to type mappings. Used for (de)serialization
      *
      * @var string[]
      */
    protected static $openAPITypes = [
        'string_item' => 'string',
        'number_item' => 'float',
        'integer_item' => 'int',
        'bool_item' => 'bool',
        'array_item' => 'int[]'
    ];

    /**
      * Array of property to format mappings. Used for (de)serialization
      *
      * @var string[]
      */
    protected static $openAPIFormats = [
        'string_item' => null,
        'number_item' => null,
        'integer_item' => null,
        'bool_item' => null,
        'array_item' => null
    ];

    /**
      * Array of nullable properties. Used for (de)serialization
      *
      * @var boolean[]
      */
    protected static $openAPINullables = [
        'string_item' => false,
        'number_item' => false,
        'integer_item' => false,
        'bool_item' => false,
        'array_item' => false
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
        'string_item' => 'string_item',
        'number_item' => 'number_item',
        'integer_item' => 'integer_item',
        'bool_item' => 'bool_item',
        'array_item' => 'array_item'
    ];

    /**
     * Array of attributes to setter functions (for deserialization of responses)
     *
     * @var string[]
     */
    protected static $setters = [
        'string_item' => 'setStringItem',
        'number_item' => 'setNumberItem',
        'integer_item' => 'setIntegerItem',
        'bool_item' => 'setBoolItem',
        'array_item' => 'setArrayItem'
    ];

    /**
     * Array of attributes to getter functions (for serialization of requests)
     *
     * @var string[]
     */
    protected static $getters = [
        'string_item' => 'getStringItem',
        'number_item' => 'getNumberItem',
        'integer_item' => 'getIntegerItem',
        'bool_item' => 'getBoolItem',
        'array_item' => 'getArrayItem'
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
        $this->setIfExists('string_item', $data, 'what');
        $this->setIfExists('number_item', $data, null);
        $this->setIfExists('integer_item', $data, null);
        $this->setIfExists('bool_item', $data, true);
        $this->setIfExists('array_item', $data, null);
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

        if ($this->container['string_item'] === null) {
            $invalidProperties[] = "'string_item' can't be null";
        }
        if ($this->container['number_item'] === null) {
            $invalidProperties[] = "'number_item' can't be null";
        }
        if ($this->container['integer_item'] === null) {
            $invalidProperties[] = "'integer_item' can't be null";
        }
        if ($this->container['bool_item'] === null) {
            $invalidProperties[] = "'bool_item' can't be null";
        }
        if ($this->container['array_item'] === null) {
            $invalidProperties[] = "'array_item' can't be null";
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
     * Gets string_item
     *
     * @return string
     */
    public function getStringItem()
    {
        return $this->container['string_item'];
    }

    /**
     * Sets string_item
     *
     * @param string $string_item string_item
     *
     * @return $this
     */
    public function setStringItem($string_item)
    {

        if (is_null($string_item)) {
            throw new \InvalidArgumentException('non-nullable string_item cannot be null');
        }

        $this->container['string_item'] = $string_item;

        return $this;
    }

    /**
     * Gets number_item
     *
     * @return float
     */
    public function getNumberItem()
    {
        return $this->container['number_item'];
    }

    /**
     * Sets number_item
     *
     * @param float $number_item number_item
     *
     * @return $this
     */
    public function setNumberItem($number_item)
    {

        if (is_null($number_item)) {
            throw new \InvalidArgumentException('non-nullable number_item cannot be null');
        }

        $this->container['number_item'] = $number_item;

        return $this;
    }

    /**
     * Gets integer_item
     *
     * @return int
     */
    public function getIntegerItem()
    {
        return $this->container['integer_item'];
    }

    /**
     * Sets integer_item
     *
     * @param int $integer_item integer_item
     *
     * @return $this
     */
    public function setIntegerItem($integer_item)
    {

        if (is_null($integer_item)) {
            throw new \InvalidArgumentException('non-nullable integer_item cannot be null');
        }

        $this->container['integer_item'] = $integer_item;

        return $this;
    }

    /**
     * Gets bool_item
     *
     * @return bool
     */
    public function getBoolItem()
    {
        return $this->container['bool_item'];
    }

    /**
     * Sets bool_item
     *
     * @param bool $bool_item bool_item
     *
     * @return $this
     */
    public function setBoolItem($bool_item)
    {

        if (is_null($bool_item)) {
            throw new \InvalidArgumentException('non-nullable bool_item cannot be null');
        }

        $this->container['bool_item'] = $bool_item;

        return $this;
    }

    /**
     * Gets array_item
     *
     * @return int[]
     */
    public function getArrayItem()
    {
        return $this->container['array_item'];
    }

    /**
     * Sets array_item
     *
     * @param int[] $array_item array_item
     *
     * @return $this
     */
    public function setArrayItem($array_item)
    {

        if (is_null($array_item)) {
            throw new \InvalidArgumentException('non-nullable array_item cannot be null');
        }

        $this->container['array_item'] = $array_item;

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


