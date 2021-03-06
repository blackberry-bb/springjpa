package com.terry.springjpa.entity;

import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ForeignKey;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.joda.time.LocalDateTime;

import com.terry.springjpa.entity.embed.InsertUpdateDT;

@Entity
@Table(name="UNITEDBOARD")
@SequenceGenerator(name="UnitedBoardSequenceGenerator", sequenceName="UNITEDBOARD_SEQUENCE", initialValue=1, allocationSize=1)
@Access(AccessType.FIELD)
public class UnitedBoard extends Board {

	private Long idx;
	
	@ManyToOne(fetch=FetchType.LAZY, optional=false)
	@JoinColumn(name="BOARDTYPE_IDX", referencedColumnName="IDX", nullable=false)
	private BoardType boardType;
	
	@ManyToOne(fetch=FetchType.LAZY, optional=false)
	@JoinColumn(name="MEMBER_IDX", referencedColumnName="IDX", nullable=false)
	// @JoinColumn(foreignKey = @ForeignKey(name="FK_MEMBER", foreignKeyDefinition="FOREIGN KEY(MEMBER_IDX) REFERENCES MEMBER"))
	private Member member;
	
	@Embedded
	private InsertUpdateDT insertUpdateDT;

	@Id
	@Column(name="IDX")
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="UnitedBoardSequenceGenerator")
	@Access(AccessType.PROPERTY)
	public Long getIdx() {
		return idx;
	}

	public void setIdx(Long idx) {
		this.idx = idx;
	}

	public BoardType getBoardType() {
		return boardType;
	}

	public void setBoardType(BoardType boardType) {
		this.boardType = boardType;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public InsertUpdateDT getInsertUpdateDT() {
		return insertUpdateDT;
	}

	public void setInsertUpdateDT(InsertUpdateDT insertUpdateDT) {
		this.insertUpdateDT = insertUpdateDT;
	}
	
	@PrePersist
	public void onCreate(){
		insertUpdateDT = new InsertUpdateDT();
		insertUpdateDT.setInsertDateTime(LocalDateTime.now());
	}
	
	@PreUpdate
	public void onUpdate(){
		insertUpdateDT.setUpdateDateTime(LocalDateTime.now());
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((boardType == null) ? 0 : boardType.hashCode());
		result = prime * result + ((idx == null) ? 0 : idx.hashCode());
		result = prime * result + ((member == null) ? 0 : member.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (!(obj instanceof UnitedBoard))
			return false;
		UnitedBoard other = (UnitedBoard) obj;
		if (boardType == null) {
			if (other.getBoardType() != null)
				return false;
		} else if (!boardType.equals(other.getBoardType()))
			return false;
		if (idx == null) {
			if (other.getIdx() != null)
				return false;
		} else if (!idx.equals(other.getIdx()))
			return false;
		if (member == null) {
			if (other.getMember() != null)
				return false;
		} else if (!member.equals(other.getMember()))
			return false;
		return true;
	}	
}
