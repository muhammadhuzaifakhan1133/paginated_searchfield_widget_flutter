// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:searchfield/searchfield.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_textStyles.dart';

// class SearchableTextfield extends StatefulWidget {
//   final Future<List<Object>> Function(String query, int page) fetchSuggestions;
//   final String Function(Object)? showValue;
//   final dynamic Function(SearchFieldListItem<Object>)? onSuggestionTap;
//   final String? searchFieldCaption;
//   final TextEditingController? textController;
//   final String? hintText;
//   final FocusNode? focusNode;
//   final double? width;
//   final double? height;
//   final bool? enabled;
//   final Widget? suffixIcon;
//   final Function(PointerDownEvent)? onTapOutside;
//   final int itemsPerPage;
//   final int totalItemCount;

//   const SearchableTextfield({
//     super.key,
//     required this.fetchSuggestions,
//     this.showValue,
//     this.onSuggestionTap,
//     this.searchFieldCaption,
//     this.textController,
//     this.hintText,
//     this.focusNode,
//     this.width,
//     this.height,
//     this.enabled,
//     this.suffixIcon,
//     this.onTapOutside,
//     this.itemsPerPage = 10,
//     required this.totalItemCount,
//   });

//   @override
//   _SearchableTextfieldState createState() => _SearchableTextfieldState();
// }

// class _SearchableTextfieldState extends State<SearchableTextfield> {
//   List<Object> suggestions = [];
//   bool isLoading = false;
//   String currentQuery = '';
//   int currentPage = 1;
//   bool hasMoreData = true;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   if (widget.textController != null) {
//   //     widget.textController!.addListener(() {
//   //       if (currentQuery != widget.textController!.text) {
//   //         _resetAndFetch(widget.textController!.text);
//   //       }
//   //     });
//   //   }
//   // }

//   Future<void> _fetchSuggestions(String query, bool reset) async {
//     if (isLoading || !hasMoreData) return;

//     setState(() {
//       isLoading = true;
//       if (reset) {
//         currentPage = 1;
//         suggestions.clear();
//         hasMoreData = true;
//       }
//     });

//     final newSuggestions =
//         await widget.fetchSuggestions(query, currentPage).catchError((error) {
//       setState(() => isLoading = false);
//     });

//     setState(() {
//       suggestions = newSuggestions;
//       hasMoreData = suggestions.length < widget.totalItemCount;
//       isLoading = false;
//       currentPage++;
//     });
//   }

//   void _resetAndFetch(String query) {
//     currentQuery = query;
//     _fetchSuggestions(query, true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.searchFieldCaption != null) ...[
//           Text(widget.searchFieldCaption!,
//               style: AppTextStyles.pop600gray15.copyWith()),
//           const SizedBox(height: 5),
//         ],
//         SizedBox(
//           width: widget.width ?? (context.width > 750 ? 300 : context.width),
//           height: widget.height ?? 39,
//           child: SearchField(
//             onScroll: (offset, maxOffset) {
//               if (offset >= maxOffset && hasMoreData && !isLoading) {
//                 _fetchSuggestions(currentQuery, false);
//               }
//             },
//             onSearchTextChanged: (query) {
//               if (query.isEmpty) {

//               } else if (currentQuery != query) {
//                 _resetAndFetch(query);
//               }
//             },
//             suggestions: suggestions
//                 .map(
//                   (e) => SearchFieldListItem(
//                     widget.showValue != null ? widget.showValue!(e) : e.toString(),
//                     item: e,
//                     child: Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Text(
//                         widget.showValue != null
//                             ? widget.showValue!(e)
//                             : e.toString(),
//                         style: AppTextStyles.pop600Blue17
//                             .copyWith(fontWeight: FontWeight.w400),
//                       ),
//                     ),
//                   ),
//                 )
//                 .toList(),
//             onSuggestionTap: widget.onSuggestionTap,
//             enabled: widget.enabled,
//             focusNode: widget.focusNode,
//             controller: widget.textController,
//             // searchInputDecoration: SearchInputDecoration(
//             //   hintText: widget.hintText,
//             //   suffixIcon: widget.suffixIcon,
//             //   hintStyle: AppTextStyles.pop600Blue17.copyWith(
//             //     color: Colors.grey.shade500,
//             //     fontSize: 14,
//             //     fontWeight: FontWeight.w400,
//             //   ),
//             //   fillColor: AppColors.textFieldColor,
//             //   filled: true,
//             //   enabledBorder: OutlineInputBorder(
//             //     borderRadius: BorderRadius.circular(4),
//             //     borderSide: const BorderSide(color: AppColors.textFieldColor),
//             //   ),
//             //   focusedBorder: OutlineInputBorder(
//             //     borderRadius: BorderRadius.circular(4),
//             //     borderSide: const BorderSide(color: AppColors.textFieldColor),
//             //   ),
//             //   border: OutlineInputBorder(
//             //     borderRadius: BorderRadius.circular(4),
//             //     borderSide: const BorderSide(color: AppColors.textFieldColor),
//             //   ),
//             //   contentPadding:
//             //       const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             // ),
//             // suggestionsDecoration:
//             //     SuggestionDecoration(color: AppColors.whiteColor),
//             onTapOutside: widget.onTapOutside,
//           ),
//         ),
//         if (isLoading) ...[
//           const SizedBox(height: 5),
//           Center(
//             child: CircularProgressIndicator(
//               color: AppColors.appThemeColor,
//               strokeWidth: 2,
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

import '../utils/app_colors.dart';
import '../utils/app_textStyles.dart';

class SearchableTextfield extends StatelessWidget {
  final List<Object> suggestions;
  final TextEditingController textController;
  bool hasMore;
  final bool isLoading;
  final Future<void> Function(String) onFetchNewSuggestion;
  final Future<void> Function(String, int) onFetchNextPage;
  final dynamic Function(SearchFieldListItem<Object>) onSuggestionTap;
  final bool pagination;
  final String? searchFieldCaption;
  final String? hintText;
  final FocusNode? focusNode;
  final double? width;
  final dynamic Function(String)? onSubmit;
  final String Function(Object)? showValue;
  final bool? enabled;
  final String Function(Object)? selectKey;
  final double? height;
  final List<SearchFieldListItem<Object>>? Function(String)?
      onSearchTextChanged;
  final Widget? suffixIcon;
  final Function(PointerDownEvent)? onTapOutside;
  final int currentPage;
  SearchableTextfield({
    super.key,
    required this.suggestions,
    required this.hasMore,
    required this.onFetchNewSuggestion,
    required this.onFetchNextPage,
    required this.isLoading,
    required this.currentPage,
    required this.textController,
    required this.onSuggestionTap,
    this.searchFieldCaption,
    this.pagination = true,
    this.width,
    this.hintText,
    this.onSubmit,
    this.focusNode,
    this.showValue,
    this.enabled,
    this.selectKey,
    this.height,
    this.suffixIcon,
    this.onTapOutside,
    this.onSearchTextChanged,
  });

  Timer? timer;
  bool isFetchingNextPage = false;

  @override
  Widget build(BuildContext context) {
    if (!pagination) hasMore = false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchFieldCaption != null) ...[
          Text(searchFieldCaption!,
              style: AppTextStyles.pop600gray15.copyWith()),
          const SizedBox(height: 5),
        ],
        SizedBox(
          width: width ?? (context.width > 750 ? 300 : context.width),
          height: height ?? 39,
          child: SearchField(
            onScroll: (offset, maxOffset) {
              if (offset >= maxOffset &&
                  hasMore &&
                  !isLoading &&
                  !isFetchingNextPage) {
                isFetchingNextPage = true;
                onFetchNextPage(textController!.text, currentPage + 1);
              }
            },
            showEmpty: hasMore && isLoading ? true : false,
            onSearchTextChanged: (query) {
              if (pagination) {
                if (timer != null) {
                  timer!.cancel();
                }
                timer = Timer(Duration(seconds: 1), () {
                  if (!isLoading) {
                    print("Is Loading in On Search Text Changed: $isLoading");
                    onFetchNewSuggestion(query);
                  }
                });
              } else {
                if (query.isEmpty) {
                  return suggestions.map((e) {
                    return SearchFieldListItem(
                      selectKey != null ? selectKey!(e) : e.toString(),
                      item: e,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          showValue != null ? showValue!(e) : e.toString(),
                          style: AppTextStyles.pop600Blue17
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList();
                }
                List<SearchFieldListItem<Object>> searchResult = [];
                for (final suggestion in suggestions) {
                  if ((selectKey != null
                          ? selectKey!(suggestion)
                          : (showValue != null
                              ? showValue!(suggestion)
                              : suggestion.toString()))
                      .toLowerCase()
                      .contains(query.toLowerCase())) {
                    searchResult.add(SearchFieldListItem(
                      selectKey != null
                          ? selectKey!(suggestion)
                          : suggestion.toString(),
                      item: suggestion,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          showValue != null
                              ? showValue!(suggestion)
                              : suggestion.toString(),
                          style: AppTextStyles.pop600Blue17
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ));
                  }
                }
                return searchResult;
              }
            },
            // onSearchTextChanged: onChangedAction,
            enabled: enabled,
            focusNode: focusNode,
            onSubmit: onSubmit,
            controller: textController,
            emptyWidget: hasMore && isLoading
                ? const Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(),
            // marginColor: AppColors.whiteColor,
            suggestionsDecoration:
                SuggestionDecoration(color: AppColors.whiteColor),
            suggestions: suggestions
                    .map(
                      (e) => SearchFieldListItem(
                        selectKey != null ? selectKey!(e) : e.toString(),
                        item: e,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            showValue != null ? showValue!(e) : e.toString(),
                            style: AppTextStyles.pop600Blue17
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )
                    .toList() +
                (hasMore
                    ? [
                        SearchFieldListItem(
                          "",
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        )
                      ]
                    : []),
            onTapOutside: onTapOutside,
            searchInputDecoration: SearchInputDecoration(
                hintText: hintText,
                suffixIcon: suffixIcon,
                hintStyle: AppTextStyles.pop600Blue17.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                fillColor: AppColors.textFieldColor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.textFieldColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.textFieldColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.textFieldColor),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            onSuggestionTap: onSuggestionTap,
          ),
        ),
      ],
    );
  }
}
