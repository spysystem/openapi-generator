# coding: utf-8

"""
    OpenAPI Petstore

    This spec is mainly for testing Petstore server and contains fake endpoints, models. Please do not use this for any other purpose. Special characters: \" \\  # noqa: E501

    OpenAPI spec version: 1.0.0
    Generated by: https://openapi-generator.tech
"""


import pprint
import re  # noqa: F401

import six


class Animal(object):
    """NOTE: This class is auto generated by OpenAPI Generator.
    Ref: https://openapi-generator.tech

    Do not edit the class manually.
    """

    """
    Attributes:
      openapi_types (dict): The key is attribute name
                            and the value is attribute type.
      attribute_map (dict): The key is attribute name
                            and the value is json key in definition.
    """
    openapi_types = {
        'class_name': 'str',
        'color': 'str'
    }

    attribute_map = {
        'class_name': 'className',
        'color': 'color'
    }

    discriminator_value_class_map = {
        'Dog': 'Dog',
        'Cat': 'Cat'
    }

    def __init__(self, class_name=None, color='red'):  # noqa: E501
        """Animal - a model defined in OpenAPI"""  # noqa: E501

        self._class_name = None
        self._color = None
        self.discriminator = 'className'

        self.class_name = class_name
        if color is not None:
            self.color = color

    @property
    def class_name(self):
        """Gets the class_name of this Animal.  # noqa: E501


        :return: The class_name of this Animal.  # noqa: E501
        :rtype: str
        """
        return self._class_name

    @class_name.setter
    def class_name(self, class_name):
        """Sets the class_name of this Animal.


        :param class_name: The class_name of this Animal.  # noqa: E501
        :type: str
        """
        if class_name is None:
            raise ValueError("Invalid value for `class_name`, must not be `None`")  # noqa: E501

        self._class_name = class_name

    @property
    def color(self):
        """Gets the color of this Animal.  # noqa: E501


        :return: The color of this Animal.  # noqa: E501
        :rtype: str
        """
        return self._color

    @color.setter
    def color(self, color):
        """Sets the color of this Animal.


        :param color: The color of this Animal.  # noqa: E501
        :type: str
        """

        self._color = color

    def get_real_child_model(self, data):
        """Returns the real base class specified by the discriminator"""
        discriminator_value = data[self.discriminator]
        return self.discriminator_value_class_map.get(discriminator_value)

    def to_dict(self):
        """Returns the model properties as a dict"""
        result = {}

        for attr, _ in six.iteritems(self.openapi_types):
            value = getattr(self, attr)
            if isinstance(value, list):
                result[attr] = list(map(
                    lambda x: x.to_dict() if hasattr(x, "to_dict") else x,
                    value
                ))
            elif hasattr(value, "to_dict"):
                result[attr] = value.to_dict()
            elif isinstance(value, dict):
                result[attr] = dict(map(
                    lambda item: (item[0], item[1].to_dict())
                    if hasattr(item[1], "to_dict") else item,
                    value.items()
                ))
            else:
                result[attr] = value

        return result

    def to_str(self):
        """Returns the string representation of the model"""
        return pprint.pformat(self.to_dict())

    def __repr__(self):
        """For `print` and `pprint`"""
        return self.to_str()

    def __eq__(self, other):
        """Returns true if both objects are equal"""
        if not isinstance(other, Animal):
            return False

        return self.__dict__ == other.__dict__

    def __ne__(self, other):
        """Returns true if both objects are not equal"""
        return not self == other
