export interface Product{
    id: number;
    name: string;
    description: string;
    price: number;
    categoryName:string;
    imagenUrl?:string;
    statusId:number;
}