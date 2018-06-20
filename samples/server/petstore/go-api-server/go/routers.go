/*
 * OpenAPI Petstore
 *
 * This is a sample server Petstore server. For this sample, you can use the api key `special-key` to test the authorization filters.
 *
 * API version: 1.0.0
 * Generated by: OpenAPI Generator (https://openapi-generator.tech)
 */

package petstoreserver

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/gorilla/mux"
)

type Route struct {
	Name        string
	Method      string
	Pattern     string
	HandlerFunc http.HandlerFunc
}

type Routes []Route

func NewRouter() *mux.Router {
	router := mux.NewRouter().StrictSlash(true)
	for _, route := range routes {
		var handler http.Handler
		handler = route.HandlerFunc
		handler = Logger(handler, route.Name)

		router.
			Methods(route.Method).
			Path(route.Pattern).
			Name(route.Name).
			Handler(handler)
	}

	return router
}

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World!")
}

var routes = Routes{
	{
		"Index",
		"GET",
		"/v2/",
		Index,
	},

	{
		"AddPet",
		strings.ToUpper("Post"),
		"/v2/pet",
		AddPet,
	},

	{
		"DeletePet",
		strings.ToUpper("Delete"),
		"/v2/pet/{petId}",
		DeletePet,
	},

	{
		"FindPetsByStatus",
		strings.ToUpper("Get"),
		"/v2/pet/findByStatus",
		FindPetsByStatus,
	},

	{
		"FindPetsByTags",
		strings.ToUpper("Get"),
		"/v2/pet/findByTags",
		FindPetsByTags,
	},

	{
		"GetPetById",
		strings.ToUpper("Get"),
		"/v2/pet/{petId}",
		GetPetById,
	},

	{
		"UpdatePet",
		strings.ToUpper("Put"),
		"/v2/pet",
		UpdatePet,
	},

	{
		"UpdatePetWithForm",
		strings.ToUpper("Post"),
		"/v2/pet/{petId}",
		UpdatePetWithForm,
	},

	{
		"UploadFile",
		strings.ToUpper("Post"),
		"/v2/pet/{petId}/uploadImage",
		UploadFile,
	},

	{
		"DeleteOrder",
		strings.ToUpper("Delete"),
		"/v2/store/order/{orderId}",
		DeleteOrder,
	},

	{
		"GetInventory",
		strings.ToUpper("Get"),
		"/v2/store/inventory",
		GetInventory,
	},

	{
		"GetOrderById",
		strings.ToUpper("Get"),
		"/v2/store/order/{orderId}",
		GetOrderById,
	},

	{
		"PlaceOrder",
		strings.ToUpper("Post"),
		"/v2/store/order",
		PlaceOrder,
	},

	{
		"CreateUser",
		strings.ToUpper("Post"),
		"/v2/user",
		CreateUser,
	},

	{
		"CreateUsersWithArrayInput",
		strings.ToUpper("Post"),
		"/v2/user/createWithArray",
		CreateUsersWithArrayInput,
	},

	{
		"CreateUsersWithListInput",
		strings.ToUpper("Post"),
		"/v2/user/createWithList",
		CreateUsersWithListInput,
	},

	{
		"DeleteUser",
		strings.ToUpper("Delete"),
		"/v2/user/{username}",
		DeleteUser,
	},

	{
		"GetUserByName",
		strings.ToUpper("Get"),
		"/v2/user/{username}",
		GetUserByName,
	},

	{
		"LoginUser",
		strings.ToUpper("Get"),
		"/v2/user/login",
		LoginUser,
	},

	{
		"LogoutUser",
		strings.ToUpper("Get"),
		"/v2/user/logout",
		LogoutUser,
	},

	{
		"UpdateUser",
		strings.ToUpper("Put"),
		"/v2/user/{username}",
		UpdateUser,
	},
}
