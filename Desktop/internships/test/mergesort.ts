
export function merge(collection_1:number[],collection_2:number[]) : number[]{
    let resualt:number[] = []
    let poscol1 = 0
    let poscol2 = 0
    // เริ่มดูตั้งแต่ตัวแรกของทั้ง 2 list เนื่องจาก แต่ละ list เลียงมาแล้ว
    while(true){
        if(poscol1 < collection_1.length && poscol2 < collection_2.length){
            //กรณีทียังไม่listอยู่ตัวสุดท้าย
            if(collection_1[poscol1] >= collection_2[poscol2]){
                resualt.push(collection_2[poscol2])
                poscol2++
                // ค่าใน ตำแหน่งที่อยู่ในlist1 มากกว่าเท่ากับ ค่าในตำแหน่งที่อยู่ใน listที่2 เพิมตัวใน list2 แล้วขยับไปตัวที่มากกว่า
            }
            if(collection_2[poscol2] >= collection_1[poscol1]){
                resualt.push(collection_1[poscol1])
                poscol1++
                // ค่าใน ตำแหน่งที่อยู่ในlist2 มากกว่าเท่ากับ ค่าในตำแหน่งที่อยู่ใน listที่1 เพิมตัวใน list1 แล้วขยับไปตัวที่มากกว่า
            }
        }else{
            //มี listนึงไล่หมดแล้ว เราจะไล่เพิ่มอีก list ให้หมด
            if(poscol1 === collection_1.length){
                while(poscol2<collection_2.length){
                    resualt.push(collection_2[poscol2])
                    poscol2++
                }
            }else{
                while(poscol1<collection_1.length){
                    resualt.push(collection_1[poscol1])
                    poscol1++
                }
            }
            return resualt
        }
    }
}
const ans = merge([1,2,8],[5,6,7])
console.log(ans)