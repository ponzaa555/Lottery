"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.merge = void 0;
function merge(collection_1, collection_2) {
    var resualt = [];
    var poscol1 = 0;
    var poscol2 = 0;
    while (true) {
        if (poscol1 < collection_1.length && poscol2 < collection_2.length) {
            if (collection_1[poscol1] >= collection_2[poscol2]) {
                resualt.push(collection_2[poscol2]);
                poscol2++;
            }
            if (collection_2[poscol2] >= collection_1[poscol1]) {
                resualt.push(collection_1[poscol1]);
                poscol1++;
            }
        }
        else {
            if (poscol1 === collection_1.length) {
                while (poscol2 < collection_2.length) {
                    resualt.push(collection_2[poscol2]);
                    poscol2++;
                }
            }
            else {
                while (poscol1 < collection_1.length) {
                    resualt.push(collection_1[poscol1]);
                    poscol1++;
                }
            }
            return resualt;
        }
    }
}
exports.merge = merge;
var ans = merge([1, 2, 8], [5, 6, 7]);
console.log(ans);
