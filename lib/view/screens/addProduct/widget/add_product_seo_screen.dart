
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/add_product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/shop_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddProductSeoScreen extends StatefulWidget {
  final ValueChanged<bool>? isSelected;
  final Product? product;
  final String? unitPrice;
  final String? purchasePrice;
  final String? discount;
  final String? currentStock;
  final String? minimumOrderQuantity;
  final String? tax;
  final String? shippingCost;
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;
  final String? brandyId;
  final String? unit;



  final AddProductModel? addProduct;
  const AddProductSeoScreen({Key? key, this.isSelected, required this.product,required this.addProduct,
    this.unitPrice, this.purchasePrice,
    this.tax, this.discount, this.currentStock,
    this.shippingCost, this.categoryId, this.subCategoryId, this.subSubCategoryId, this.brandyId, this.unit, this.minimumOrderQuantity}) : super(key: key);

  @override
  AddProductSeoScreenState createState() => AddProductSeoScreenState();
}

class AddProductSeoScreenState extends State<AddProductSeoScreen> {
  bool isSelected = false;
  final FocusNode _seoTitleNode = FocusNode();
  final FocusNode _seoDescriptionNode = FocusNode();
  final FocusNode _youtubeLinkNode = FocusNode();
  final TextEditingController _seoTitleController = TextEditingController();
  final TextEditingController _seoDescriptionController = TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();
  AutoCompleteTextField? searchTextField;
  late double _distanceToField;
  TextfieldTagsController? _controller;


  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  SimpleAutoCompleteTextField? textField;
  bool showWhichErrorText = false;
  late bool _update;
  Product? _product;
  AddProductModel? _addProduct;
  String? thumbnailImage ='', metaImage ='';
  int counter = 0, total = 0;
  int addColor = 0;
  List<String> tagList = [];




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  void initState() {
    Provider.of<SellerProvider>(context,listen: false).colorImageObject = [];
    Provider.of<SellerProvider>(context,listen: false).productReturnImage = [];
    _product = widget.product;
    _update = widget.product != null;
    _addProduct = widget.addProduct;
    if(_update) {
      if(_product!.tags != null){
        for(int i = 0; i< _product!.tags!.length; i++){
          tagList.add(_product!.tags![i].tag!);
        }
      }

      _seoTitleController.text = _product!.metaTitle!;
      _seoDescriptionController.text = _product!.metaDescription??'';
      thumbnailImage = _product!.thumbnail;
      metaImage = _product!.metaImage;
      Provider.of<SellerProvider>(context,listen: false).productReturnImage = _product!.images;
    }else {
      _product = Product();
      _addProduct = AddProductModel();


    }
    _controller = TextfieldTagsController();
    super.initState();
  }



  route(bool isRoute, String name, String type, String? colorCode) async {
    if (isRoute) {
      if(_update){
        if(thumbnailImage=='' && metaImage ==''){
          total = Provider.of<SellerProvider>(context,listen: false).withColor.length+ Provider.of<SellerProvider>(context,listen: false).withoutColor.length;
        }else if(Provider.of<SellerProvider>(context,listen: false).productReturnImage!.isEmpty && metaImage ==''){
          total = 1;
        }else if(thumbnailImage=='' && Provider.of<SellerProvider>(context,listen: false).productReturnImage!.isEmpty && metaImage ==''){
          total = 0;
        }else if(thumbnailImage=='' && Provider.of<SellerProvider>(context,listen: false).productReturnImage!.isEmpty){
          total = 1;
        }
      }
      if(type == 'meta'){metaImage = name;}
      else if(type == 'thumbnail'){thumbnailImage = name;}
      else{
        if(Provider.of<SellerProvider>(context,listen: false).withColor.isNotEmpty) {
          for(int index=0; index<Provider.of<SellerProvider>(context,listen: false).withColor.length; index++) {
            String retColor = Provider.of<SellerProvider>(context,listen: false).withColor[index].color!;
            String? bb;
            if(retColor.contains('#')){
              bb = retColor.replaceAll('#', '');
            }
            if(bb == colorCode) {
              Provider.of<SellerProvider>(context,listen: false).setStringImage(index, name, colorCode!);
              break;
            }
          }
        }
         if(Provider.of<SellerProvider>(context,listen: false).withoutColor.isNotEmpty) {
          for(int index=0; index<Provider.of<SellerProvider>(context,listen: false).withoutColor.length; index++) {
          }
        }
      }
      counter++;

      if(metaImage ==''){
        total = Provider.of<SellerProvider>(context,listen: false).withColor.length+ Provider.of<SellerProvider>(context,listen: false).withoutColor.length + 1;
      }else{

        total = Provider.of<SellerProvider>(context,listen: false).withColor.length+ Provider.of<SellerProvider>(context,listen: false).withoutColor.length + 2;
      }
      if(counter == total) {
        counter++;
        Provider.of<SellerProvider>(context,listen: false).addProduct(
            context, _product!, _addProduct!, Provider.of<SellerProvider>(context,listen: false).productReturnImage, Provider.of<SellerProvider>(context,listen: false).colorImageObject, thumbnailImage, metaImage,
            Provider.of<AuthProvider>(context,listen: false).getUserToken(),
            !_update,Provider.of<SellerProvider>(context,listen: false).attributeList![0].active, tagList);
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title:  widget.product != null ?
      getTranslated('update_product', context):
      getTranslated('add_product', context),),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Consumer<SellerProvider>(
          builder: (context, resProvider, child){
            return SingleChildScrollView(
              child: (resProvider.attributeList != null &&
                  resProvider.attributeList!.isNotEmpty &&
                  resProvider.categoryList != null &&
                  Provider.of<SplashProvider>(context,listen: false).colorList!= null) ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(getTranslated('tags', context)!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // TextFieldTags(
                  //   textfieldTagsController: _controller,
                  //   initialTags:( _update && tagList.isNotEmpty)  ?  tagList! : const [],
                  //   textSeparators: const [' ', ','],
                  //   letterCase: LetterCase.normal,
                  //   validator: (dynamic tag) {
                  //     if (tag == 'php') {
                  //       return 'No, please just no';
                  //     } else if (_controller!.getTags!.contains(tag)) {
                  //       return 'you already entered that';
                  //     }
                  //     return null;
                  //   },
                  //    inputFieldBuilder: (BuildContext context, InputFieldValues<dynamic> textFieldTagValues) {
                  //      return TextField(
                  //         controller: tec,
                  //         focusNode: fn,
                  //         decoration: InputDecoration(
                  //           isDense: true,
                  //           border: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: Theme.of(context).primaryColor,
                  //               width: 3.0,
                  //             ),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: Theme.of(context).primaryColor,
                  //               width: 3.0,
                  //             ),
                  //           ),
                  //           helperText: '',
                  //           helperStyle: TextStyle(
                  //             color: Theme.of(context).primaryColor,
                  //           ),
                  //           hintText: _controller!.getTags. ? '' : "Enter tag...",
                  //           errorText: error,
                  //           prefixIconConstraints:
                  //           BoxConstraints(maxWidth: _distanceToField * 0.74),
                  //           prefixIcon: tags.isNotEmpty
                  //               ? SingleChildScrollView(
                  //             controller: sc,
                  //             scrollDirection: Axis.horizontal,
                  //             child: Row(
                  //                 children: tags.map((String? tag) {
                  //                   if (kDebugMode) {
                  //                     print('Here is your tag===>${tags.toList()}/${tagList.toList()}');
                  //                   }
                  //                   return Container(
                  //                     decoration: BoxDecoration(
                  //                       borderRadius: const BorderRadius.all(
                  //                         Radius.circular(20.0),
                  //                       ),
                  //                       color: Theme.of(context).primaryColor,
                  //                     ),
                  //                     margin: const EdgeInsets.symmetric(
                  //                         horizontal: 5.0),
                  //                     padding: const EdgeInsets.symmetric(
                  //                         horizontal: 10.0, vertical: 5.0),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         InkWell(
                  //                           child: Text(
                  //                             '$tag',
                  //                             style: const TextStyle(
                  //                                 color: Colors.white),
                  //                           ),
                  //                           onTap: () {
                  //                             //print("$tag selected");
                  //                           },
                  //                         ),
                  //                         const SizedBox(width: 4.0),
                  //                         InkWell(
                  //                           child: const Icon(
                  //                             Icons.cancel,
                  //                             size: 14.0,
                  //                             color: Color.fromARGB(
                  //                                 255, 233, 233, 233),
                  //                           ),
                  //                           onTap: () {
                  //                             onTagDelete(tag!);
                  //                           },
                  //                         )
                  //                       ],
                  //                     ),
                  //                   );
                  //                 }).toList()),
                  //           )
                  //               : null,
                  //         ),
                  //         onChanged: onChanged,
                  //         onSubmitted: onSubmitted,
                  //       );
                  //     },),






                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                        child: Text(getTranslated('product_seo_settings', context)!,
                            style: robotoBold.copyWith(color: ColorResources.getHeadTextColor(context),
                            fontSize: Dimensions.fontSizeExtraLarge)),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(getTranslated('meta_title', context)!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),


                  CustomTextField(
                    border: true,
                    textInputType: TextInputType.name,
                    focusNode: _seoTitleNode,
                    controller: _seoTitleController,
                    nextNode: _seoDescriptionNode,
                    textInputAction: TextInputAction.next,
                    hintText: getTranslated('meta_title', context),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(getTranslated('meta_description', context)!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  CustomTextField(
                    isDescription:true,
                    border: true,
                    controller: _seoDescriptionController,
                    focusNode: _seoDescriptionNode,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.multiline,
                    maxLine: 3,
                    hintText: getTranslated('meta_description_hint', context),

                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),


                  Text(getTranslated('youtube_video_link', context)!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  CustomTextField(
                    textInputType: TextInputType.text,
                    controller: _youtubeLinkController,
                    focusNode: _youtubeLinkNode,
                    textInputAction: TextInputAction.done,
                    hintText: 'https://www.youtube.com/embed/HHE7',

                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),



                  Text(getTranslated('meta_image', context)!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Align(alignment: Alignment.center, child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      child: resProvider.pickedMeta != null? Image.file(
                        File(resProvider.pickedMeta!.path), width: 150, height: 120, fit: BoxFit.cover,
                      ) :widget.product!=null? FadeInImage.assetNetwork(
                        placeholder: Images.placeholderImage,
                        image: '${Provider.of<SplashProvider>(context).configModel!.
                        baseUrls!.productImageUrl}/meta/${_product!.metaImage ?? ''}',
                        height: 120, width: 150, fit: BoxFit.cover,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 120,
                            width: 150, fit: BoxFit.cover),
                      ):Image.asset(Images.placeholderImage, height: 120,
                          width: 150, fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => resProvider.pickImage(false,true, false, null),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ])),


                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(getTranslated('thumbnail', context)!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),




                  Align(alignment: Alignment.center, child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      child: resProvider.pickedLogo != null ?  Image.file(File(resProvider.pickedLogo!.path),
                        width: 150, height: 120, fit: BoxFit.cover,
                      ) :widget.product!=null? FadeInImage.assetNetwork(
                        placeholder: Images.placeholderImage,
                        image: '${Provider.of<SplashProvider>(context).configModel!.
                        baseUrls!.productThumbnailUrl}/${_product!.thumbnail ?? ''}',
                        height: 120, width: 150, fit: BoxFit.cover,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage,
                            height: 120, width: 150, fit: BoxFit.cover),
                      ):Image.asset(Images.placeholderImage,height: 120,
                        width: 150, fit: BoxFit.cover,),
                    ),
                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => resProvider.pickImage(true,false, false, null),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ])),



                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(getTranslated('product_image', context)!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),


                  if(resProvider.attributeList![0].active && resProvider.attributeList![0].variants.isNotEmpty)

                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: resProvider.withColor.length,
                      itemBuilder: (context, index){
                        String colorString = '0xff000000';
                      if(resProvider.withColor[index].color != null){
                         colorString = '0xff${resProvider.withColor[index].color!.substring(1, 7)}';
                      }


                      return Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        child: (resProvider.withColor[index].color != null && resProvider.withColor[index].image == null)?
                        GestureDetector(
                          onTap: ()=> resProvider.pickImage(false, false, false, index),
                          child: Stack(children: [
                            DottedBorder(
                              dashPattern: const [4,5],
                              borderType: BorderType.RRect,
                              color: Theme.of(context).hintColor,
                              radius: const Radius.circular(15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                child:  Image.asset(Images.placeholderImage, height: MediaQuery.of(context).size.width/2.3,
                                    width: MediaQuery.of(context).size.width/2.3, fit: BoxFit.cover,),
                              ),
                            ),
                            Positioned(bottom: 0, right: 0, top: 0, left: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.camera_alt, color: Colors.black.withOpacity(.5), size: 40,),
                              ),
                            ),

                            Positioned(
                              right: 5,top: 5,
                              child: Container(
                                width: 30,height: 30,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(colorString)),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(Images.edit),
                                ),
                              ),
                            )
                          ],
                          ),
                        ):

                        Stack(children: [
                          DottedBorder(
                            dashPattern: const [4,5],
                            borderType: BorderType.RRect,
                            color: Theme.of(context).hintColor,
                            radius: const Radius.circular(15),
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20)),),
                              child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                                child: Image.file(File(resProvider.withColor[index].image!.path),
                                  width: MediaQuery.of(context).size.width/2.3,
                                  height: MediaQuery.of(context).size.width/2.3,
                                  fit: BoxFit.cover,),) ,),
                          ),

                          Positioned(top:5,right:5,
                            child: InkWell( onTap: ()=> resProvider.pickImage(false, false, false, index),
                              child: Container(
                                width: 30,height: 30,
                                decoration: BoxDecoration(
                                    color: Color(int.parse(colorString)),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(Images.edit),
                                ),
                              ),
                            ),
                          ),
                        ],
                        ),
                      );
                      }),


                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: resProvider.withoutColor.length + 1,
                    itemBuilder: (BuildContext context, index){
                    return index == resProvider.withoutColor.length ?
                    GestureDetector(
                      onTap: ()=> resProvider.pickImage(false, false, false, null),
                      child: Stack(children: [
                        DottedBorder(
                          dashPattern: const [4,5],
                          borderType: BorderType.RRect,
                          color: Theme.of(context).hintColor,
                          radius: const Radius.circular(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            child:  Image.asset(Images.placeholderImage, height: MediaQuery.of(context).size.width/2.3,
                                width: MediaQuery.of(context).size.width/2.3, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(bottom: 0, right: 0, top: 0, left: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.camera_alt, color: Colors.black.withOpacity(.5), size: 40,),
                          ),
                        ),
                      ],
                      ),
                    ) :
                    Stack(children: [
                      DottedBorder(
                        dashPattern: const [4,5],
                        borderType: BorderType.RRect,
                        color: Theme.of(context).hintColor,
                        radius: const Radius.circular(15),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),),
                          child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                            child: Image.file(File(resProvider.withoutColor[index].image!.path),
                              width: MediaQuery.of(context).size.width/2.3,
                              height: MediaQuery.of(context).size.width/2.3,
                              fit: BoxFit.cover,),) ,),
                      ),

                      Positioned(top: 5, right : 5,
                        child: InkWell(onTap :() => resProvider.removeImage(index, false),
                          child: Container(decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), blurRadius: 1,spreadRadius: 1,offset: const Offset(0,0))],
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 25,),)),
                        ),
                      ),
                    ],
                    );

                  }),

                  const SizedBox(height: 25),

                ],):const Padding(
                padding: EdgeInsets.only(top: 300.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          },

        ),
      ),),
      bottomNavigationBar: Consumer<SellerProvider>(
        builder: (context, resProvider, _) {


          return Container(height: 80,
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200]!,
                  spreadRadius: 0.5, blurRadius: 0.3)],
            ),
            child: !resProvider.isLoading ?
          CustomButton(
            btnTxt: _update ? getTranslated('update',context) : getTranslated('submit', context),
            onTap: (){

              String seoDescription = _seoDescriptionController.text.trim();
              String seoTitle = _seoTitleController.text.trim();
              String? unit = widget.unit;
              String? brandId = widget.brandyId;
              String metaTitle =_seoTitleController.text.trim();
              String metaDescription =_seoDescriptionController.text.trim();
              String videoUrl = _youtubeLinkController.text.trim();
              String multiPlyWithQuantity = resProvider.isMultiply?'1':'0';
              int multi = int.parse(multiPlyWithQuantity);
              String productCode = resProvider.productCode.text;




              List<String> titleList = [];
              List<String> descriptionList = [];
              for(TextEditingController textEditingController in resProvider.titleControllerList) {
                titleList.add(textEditingController.text.trim());
              }
              for (var description in resProvider.descriptionControllerList) {
                descriptionList.add(description.text.trim());}




              if (!_update && resProvider.pickedLogo == null) {
                showCustomSnackBar(getTranslated('upload_thumbnail_image',context),context);
              }else if (!_update && resProvider.withColor.length +resProvider.withoutColor.length == 0) {
                showCustomSnackBar(getTranslated('upload_product_image',context),context);
              }


              else {
                _addProduct = AddProductModel();
                _addProduct!.titleList = titleList;
                _addProduct!.descriptionList = descriptionList;
                _addProduct!.videoUrl = videoUrl;
                _product!.tax = double.parse(widget.tax!);
                _product!.taxModel = resProvider.taxTypeIndex == 0 ? 'include' : 'exclude';
                _product!.unitPrice = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.unitPrice!), context);
                _product!.purchasePrice = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.purchasePrice!), context);
                _product!.discount = resProvider.discountTypeIndex == 0 ?
                double.parse(widget.discount!) : PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.discount!), context);
                _product!.productType = resProvider.productTypeIndex == 0 ? 'physical' : 'digital';
                _product!.unit = unit;
                _product!.code = productCode;
                _product!.shippingCost = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.shippingCost!), context);
                _product!.multiplyWithQuantity = multi;
                _product!.brandId = int.parse(brandId!);
                _product!.metaTitle = metaTitle;
                _product!.metaDescription = metaDescription;
                _product!.currentStock = int.parse(widget.currentStock!);
                _product!.minimumOrderQty = int.parse(widget.minimumOrderQuantity!);
                _product!.metaTitle = seoTitle;
                _product!.metaDescription = seoDescription;
                _product!.discountType = resProvider.discountType;
                _product!.digitalProductType = resProvider.digitalProductTypeIndex == 0 ? 'ready_after_sell' : 'ready_product';
                _product!.digitalFileReady = resProvider.digitalProductFileName;
                _product!.categoryIds = [];
                _product!.categoryIds!.add(CategoryIds(id: widget.categoryId));

                if (resProvider.subCategoryIndex != 0) {
                  _product!.categoryIds!.add(CategoryIds(
                      id: widget.subCategoryId));}

                if (resProvider.subSubCategoryIndex != 0) {
                  _product!.categoryIds!.add(CategoryIds(
                      id: widget.subSubCategoryId));}

                _addProduct!.colorCodeList =[];
                _addProduct!.colorCodeList!.addAll(resProvider.colorCodeList);

                _addProduct!.languageList = [];
                if(Provider.of<SplashProvider>(context, listen:false).configModel!.languageList!=null &&
                    Provider.of<SplashProvider>(context, listen:false).configModel!.languageList!.isNotEmpty){
                  for(int i=0; i<Provider.of<SplashProvider>(context, listen:false).
                  configModel!.languageList!.length;i++){
                    _addProduct!.languageList!.insert(i,
                        Provider.of<SplashProvider>(context, listen:false).configModel!.languageList![i].code) ;
                  }

                }


                if(_update){
                  if(resProvider.pickedLogo == null && resProvider.pickedMeta == null &&
                      resProvider.productImage.isEmpty ){
                    Provider.of<SellerProvider>(context,listen: false).addProduct(context,
                        _product!, _addProduct!, Provider.of<SellerProvider>(context,listen: false).productReturnImage,Provider.of<SellerProvider>(context,listen: false).colorImageObject, thumbnailImage, metaImage,
                        Provider.of<AuthProvider>(context,listen: false).getUserToken(),
                        !_update,Provider.of<SellerProvider>(context,listen: false).attributeList![0].active, tagList);
                  } else{

                    if(resProvider.pickedLogo != null){
                      resProvider.addProductImage(context,resProvider.thumbnail, route);
                    }

                    if(resProvider.pickedMeta != null){
                      resProvider.addProductImage(context,resProvider.metaImage, route);
                    }

                    for(int i =0; i<resProvider.withColor.length;i++)
                    {
                      resProvider.addProductImage(context,resProvider.withColor[i], route);
                    }
                    for(int i =0; i<resProvider.withoutColor.length;i++)
                    {
                      resProvider.addProductImage(context,resProvider.withoutColor[i], route);
                    }

                  }


                }
                if(resProvider.pickedLogo != null){
                  resProvider.addProductImage(context,resProvider.thumbnail, route);
                }

                if(resProvider.pickedMeta != null){
                  resProvider.addProductImage(context,resProvider.metaImage,route);
                }



                    for(int i =0; i<resProvider.withColor.length; i++)
                    {
                      resProvider.addProductImage(context,resProvider.withColor[i], route);
                    }

                for(int i =0; i<resProvider.withoutColor.length; i++)
                {
                  resProvider.addProductImage(context,resProvider.withoutColor[i], route);
                }



              }



            },
          ):const Center(child: CircularProgressIndicator()),);
        }
      ),
    );
  }
}
